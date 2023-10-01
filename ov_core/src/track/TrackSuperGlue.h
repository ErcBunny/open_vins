//
// Created by ryan on 9/22/23.
//

#ifndef SRC_TRACKSUPERGLUE_H
#define SRC_TRACKSUPERGLUE_H

#include "TrackBase.h"
#include "SuperGlue.h"

#include <utility>
#include "cam/CamBase.h"
#include "feat/FeatureDatabase.h"

namespace ov_core {
    class TrackSuperGlue : public TrackBase
    {
    public:

        explicit TrackSuperGlue(
            std::unordered_map<size_t, std::shared_ptr<CamBase>> cameras,
            int numfeats,
            int numaruco,
            bool stereo,
            HistogramMethod histmethod,
            int min_pt_dist,
            int nms_r,
            float kpt_thr,
            bool use_indoor_weights,
            int sinkhorn_iters,
            float match_thr,
            bool use_cuda_device,
            const std::string &superglue_path)
        : TrackBase(std::move(cameras), numfeats, numaruco, stereo, histmethod)
        {
            sg_worker = new SuperGlue(
                nms_r,
                kpt_thr,
                numfeats,
                use_indoor_weights,
                sinkhorn_iters,
                match_thr,
                use_cuda_device,
                superglue_path);

            min_px_dist = min_pt_dist;
        }

        void feed_new_camera(const CameraData &message) override;

    protected:

        void feed_monocular(const CameraData &message, size_t msg_id);

        void perform_detection_monocular(const cv::Mat &img,
                                         const cv::Mat &mask,
                                         std::vector<cv::KeyPoint> &keyPoints,
                                         std::vector<float> &scores,
                                         cv::Mat &descriptors,
                                         cv::Mat &tensor,
                                         bool do_filter);

        void perform_matching_monocular(const std::vector<cv::KeyPoint> &keyPoints0,
                                        const std::vector<float> &scores0,
                                        const cv::Mat &descriptors0,
                                        const cv::Mat &tensor0,
                                        const std::vector<cv::KeyPoint> &keyPoints1,
                                        const std::vector<float> &scores1,
                                        const cv::Mat &descriptors1,
                                        const cv::Mat &tensor1,
                                        std::vector<cv::DMatch>& matches,
                                        std::vector<float>& match_conf,
                                        size_t cam_id,
                                        bool do_ransac);

        SuperGlue* sg_worker;

        std::map<size_t, std::vector<float>> kpt_scores_last;
        std::map<size_t, cv::Mat> descriptors_last;
        std::map<size_t, cv::Mat> frame_tensor_last;

        int min_px_dist;
    };
}


#endif //SRC_TRACKSUPERGLUE_H
