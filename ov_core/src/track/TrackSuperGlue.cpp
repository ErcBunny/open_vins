//
// Created by ryan on 9/22/23.
//

#include "TrackSuperGlue.h"

using namespace ov_core;

void TrackSuperGlue::feed_new_camera(const ov_core::CameraData &message)
{
    // Error check that we have all the data
    if (
        message.sensor_ids.empty() ||
        message.sensor_ids.size() != message.images.size() ||
        message.images.size() != message.masks.size()
    ) {
        PRINT_ERROR(RED "[ERROR]: MESSAGE DATA SIZES DO NOT MATCH OR EMPTY!!!\n" RESET)
        PRINT_ERROR(RED "[ERROR]:   - message.sensor_ids.size() = %zu\n" RESET, message.sensor_ids.size())
        PRINT_ERROR(RED "[ERROR]:   - message.images.size() = %zu\n" RESET, message.images.size())
        PRINT_ERROR(RED "[ERROR]:   - message.masks.size() = %zu\n" RESET, message.masks.size())
        std::exit(EXIT_FAILURE);
    }

    size_t num_images = message.images.size();
    if (num_images == 1) {
        feed_monocular(message, 0);
    }
    else if (num_images == 2) {
        PRINT_ERROR(RED "[ERROR]: only mono is supported using SuperGlue\n")
        std::exit(EXIT_FAILURE);
    }
    else {
        PRINT_ERROR(RED "[ERROR]: invalid number of images passed %zu, we only support mono or stereo tracking\n", num_images)
        std::exit(EXIT_FAILURE);
    }
}

void TrackSuperGlue::feed_monocular(const ov_core::CameraData &message, size_t msg_id)
{
    // Lock this data feed for this camera
    size_t cam_id = message.sensor_ids.at(msg_id);
    std::lock_guard<std::mutex> lck(mtx_feeds.at(cam_id));

    // Histogram equalization
    cv::Mat img, mask;
    img = message.images.at(msg_id);
    if (histogram_method == HistogramMethod::HISTOGRAM) {
        cv::equalizeHist(message.images.at(msg_id), img);
    }
    else if (histogram_method == HistogramMethod::CLAHE) {
        double eq_clip_limit = 10.0;
        cv::Size eq_win_size = cv::Size(8, 8);
        cv::Ptr<cv::CLAHE> CLAHEFunc = cv::createCLAHE(eq_clip_limit, eq_win_size);
        CLAHEFunc->apply(message.images.at(msg_id), img);
    }
    else {
        img = message.images.at(msg_id);
    }
    mask = message.masks.at(msg_id);

    // If we didn't have any successful tracks last time, just do detection this time
    if (pts_last[cam_id].empty()) {

        // Call SuperPoint to get key points
        std::vector<cv::KeyPoint> keyPoints;
        std::vector<float> scores;
        cv::Mat descriptors, frame_tensor;
        perform_detection_monocular(img, mask,
                                    keyPoints, scores, descriptors, frame_tensor,
                                    false);

        // Initial ID
        std::vector<size_t> ids;
        for (size_t i = 0; i < keyPoints.size(); i++)
        {
            size_t id = ++currid;
            ids.push_back(id);
        }

        // Update last frame variables
        std::lock_guard<std::mutex> lck_var(mtx_last_vars);
        img_last[cam_id] = img;
        img_mask_last[cam_id] = mask;
        pts_last[cam_id] = keyPoints;
        kpt_scores_last[cam_id] = scores;
        descriptors_last[cam_id] = descriptors;
        frame_tensor_last[cam_id] = frame_tensor;
        ids_last[cam_id] = ids;
        return;
    }

    // Detect features in the new frame, vars are marked 1
    rT1 = boost::posix_time::microsec_clock::local_time();
    std::vector<cv::KeyPoint> keyPoints1;
    std::vector<float> scores1;
    cv::Mat descriptors1, frame_tensor1;
    perform_detection_monocular(img, mask,
                                keyPoints1, scores1, descriptors1, frame_tensor1,
                                false);
    rT2 = boost::posix_time::microsec_clock::local_time();

    // Temporal tracking by using SuperGlue
    cv::Mat img0 = img_last[cam_id];
    std::vector<cv::KeyPoint> keyPoints0 = pts_last[cam_id];
    std::vector<float> scores0 = kpt_scores_last[cam_id];
    cv::Mat descriptors0 = descriptors_last[cam_id];
    cv::Mat frame_tensor0 = frame_tensor_last[cam_id];

    std::vector<cv::DMatch> matches;
    std::vector<float> match_conf;
    perform_matching_monocular(keyPoints0, scores0, descriptors0, frame_tensor0,
                               keyPoints1, scores1, descriptors1, frame_tensor1,
                               matches, match_conf, cam_id, true);
    if (matches.empty())
    {
        std::lock_guard<std::mutex> lck_var(mtx_last_vars);
        img_last[cam_id] = img;
        img_mask_last[cam_id] = mask;
        pts_last[cam_id].clear();
        kpt_scores_last[cam_id].clear();
        descriptors_last[cam_id] = descriptors1;
        frame_tensor_last[cam_id] = frame_tensor1;
        ids_last[cam_id].clear();
        PRINT_ERROR(RED "[SG-EXTRACTOR]: Failed to get enough points to do RANSAC, resetting.....\n" RESET)
        return;
    }
    rT3 = boost::posix_time::microsec_clock::local_time();

    // Update feature database
    int num_tracked = 0, num_new = 0;
    std::vector<size_t> ids;
    std::vector<cv::KeyPoint> keyPoints;
    std::vector<float> scores;
    cv::Mat descriptors;
    for (size_t i = 0; i < keyPoints1.size(); i++)
    {
        int id_old = -1;
        for (auto & match : matches)
        {
            if (match.trainIdx == (int)i)
            {
                id_old = match.queryIdx;
            }
        }

        keyPoints.push_back(keyPoints1[i]);
        descriptors.push_back(descriptors1.row((int)i));
        scores.push_back(scores1[i]);
        if (id_old != -1)
        {
            ids.push_back(ids_last[cam_id][id_old]);
            num_tracked += 1;
        }
        else
        {
            size_t id = ++currid;
            ids.push_back(id);
            num_new += 1;
        }
    }

    for (size_t i = 0; i < keyPoints.size(); i++)
    {
        cv::Point2f pt = camera_calib.at(cam_id)->undistort_cv(keyPoints.at(i).pt);
        database->update_feature(
                ids.at(i),
                message.timestamp, cam_id,
                keyPoints.at(i).pt.x, keyPoints.at(i).pt.y,
                pt.x, pt.y
                );

    }
    rT4 = boost::posix_time::microsec_clock::local_time();

    // Move forward in time
    {
        std::lock_guard<std::mutex> lck_var(mtx_last_vars);
        img_last[cam_id] = img;
        pts_last[cam_id] = keyPoints;
        kpt_scores_last[cam_id] = scores;
        descriptors_last[cam_id] = descriptors;
        frame_tensor_last[cam_id] = frame_tensor1;
        ids_last[cam_id] = ids;
    }

    // Timing information
    PRINT_ALL("[TIME-SG]: %.4f seconds for detection (%d new)\n",
              (rT2 - rT1).total_microseconds() * 1e-6, num_new)
    PRINT_ALL("[TIME-SG]: %.4f seconds for temporal tracking (%d tracked)\n",
              (rT3 - rT2).total_microseconds() * 1e-6, num_tracked)
    PRINT_ALL("[TIME-SG]: %.4f seconds for feature DB update (%d updated)\n",
              (rT4 - rT3).total_microseconds() * 1e-6, keyPoints.size())
    PRINT_ALL("[TIME-SG]: %.4f seconds for total\n",
              (rT4 - rT1).total_microseconds() * 1e-6)
}

void TrackSuperGlue::perform_detection_monocular(
        const cv::Mat &img, const cv::Mat &mask,
        std::vector<cv::KeyPoint> &keyPoints, std::vector<float> &scores,
        cv::Mat &descriptors, cv::Mat &tensor, bool do_filter)
{
    std::vector<cv::KeyPoint> sg_keyPoints;
    std::vector<float> sg_scores;
    cv::Mat sg_descriptors;
    cv::Mat sg_tensor;
    sg_worker->get_keypoints(img, sg_keyPoints, sg_scores, sg_descriptors, sg_tensor);

    cv::Size size((int)((float)img.cols / (float)min_px_dist), (int)((float)img.rows / (float)min_px_dist));
    cv::Mat grid_2d = cv::Mat::zeros(size, CV_8UC1);

    for (size_t i = 0; i < sg_keyPoints.size(); i++)
    {
        cv::KeyPoint kpt = sg_keyPoints.at(i);
        int x = (int)kpt.pt.x;
        int y = (int)kpt.pt.y;
        int x_grid = (int)(kpt.pt.x / (float)min_px_dist);
        int y_grid = (int)(kpt.pt.y / (float)min_px_dist);

        // Check if it is in the masked region
        if(mask.at<uint8_t>(x, y) > 127 && do_filter)
            continue;

        // Check if it is out of sight
        if (x_grid < 0 || x_grid >= size.width ||
            y_grid < 0 || y_grid >= size.height ||
            x < 0 || x >= img.cols ||
            y < 0 || y >= img.rows){
            if (do_filter)
                continue;
        }
        // Check if this keypoint is near another point
        if (grid_2d.at<uint8_t>(y_grid, x_grid) > 127 && do_filter)
            continue;

        keyPoints.push_back(sg_keyPoints.at(i));
        scores.push_back(sg_scores.at(i));
        descriptors.push_back(sg_descriptors.row((int)i));
        tensor = sg_tensor;
        grid_2d.at<uint8_t>(y_grid, x_grid) = 255;
    }
}

void TrackSuperGlue::perform_matching_monocular(
        const std::vector<cv::KeyPoint> &keyPoints0, const std::vector<float> &scores0,
        const cv::Mat &descriptors0, const cv::Mat &tensor0,
        const std::vector<cv::KeyPoint> &keyPoints1, const std::vector<float> &scores1,
        const cv::Mat &descriptors1, const cv::Mat &tensor1,
        std::vector<cv::DMatch>& matches, std::vector<float>& match_conf, size_t cam_id,
        bool do_ransac)
{
    // SuperGlue -> sg_matches
    std::vector<cv::DMatch> sg_matches;
    std::vector<float> sg_match_conf;
    sg_worker->match_keypoints(
            const_cast<std::vector<cv::KeyPoint> &>(keyPoints0),
            const_cast<std::vector<float> &>(scores0),
            descriptors0, tensor0,
            const_cast<std::vector<cv::KeyPoint> &>(keyPoints1),
            const_cast<std::vector<float> &>(scores1),
            descriptors1, tensor1,
            sg_matches, sg_match_conf);

    // Find fundamental matrix, RANSAC
    // sg_matches -> matches
    if (do_ransac)
    {
        std::vector<cv::Point2f> pts0_ransac, pts1_ransac;
        for (auto & match : sg_matches)
        {
            int idx_pt0 = match.queryIdx;
            int idx_pt1 = match.trainIdx;
            pts0_ransac.push_back(keyPoints0[idx_pt0].pt);
            pts1_ransac.push_back(keyPoints1[idx_pt1].pt);
        }

        if (pts0_ransac.size() > 10)
        {
            std::vector<cv::Point2f> pts0_ransac_norm, pts1_ransac_norm;
            for (size_t i = 0; i < pts0_ransac.size(); i++) {
                pts0_ransac_norm.push_back(camera_calib.at(cam_id)->undistort_cv(pts0_ransac.at(i)));
                pts1_ransac_norm.push_back(camera_calib.at(cam_id)->undistort_cv(pts1_ransac.at(i)));
            }
            std::vector<uchar> mask_ransac;
            double max_f = std::max(
                    camera_calib.at(cam_id)->get_K()(0, 0),
                    camera_calib.at(cam_id)->get_K()(1, 1));
            cv::findFundamentalMat(
                    pts0_ransac_norm,
                    pts1_ransac_norm,
                    cv::FM_RANSAC,
                    1 / max_f,
                    0.99,
                    mask_ransac
            );
            for (size_t i = 0; i < sg_matches.size(); i++)
            {
                if (mask_ransac[i] != 1)
                    continue;
                matches.push_back(sg_matches.at(i));
                match_conf.push_back(sg_match_conf.at(i));
            }
        }
    }
    else
    {
        matches = sg_matches;
        match_conf = sg_match_conf;
    }
}
