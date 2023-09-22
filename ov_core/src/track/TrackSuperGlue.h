//
// Created by ryan on 9/22/23.
//

#ifndef SRC_TRACKSUPERGLUE_H
#define SRC_TRACKSUPERGLUE_H

#include "TrackBase.h"
#include "SuperGlue.h"

namespace ov_core {
    class TrackSuperGlue : public TrackBase
    {
    public:
        explicit TrackSuperGlue(std::unordered_map<size_t, std::shared_ptr<CamBase>> cameras, int numfeats, int numaruco, bool stereo,
                HistogramMethod histmethod)
        : TrackBase(cameras, numfeats, numaruco, stereo, histmethod)
        {}

        void feed_new_camera(const CameraData &message) override {};
    private:
        SuperGlue* ptr;
    };
}


#endif //SRC_TRACKSUPERGLUE_H
