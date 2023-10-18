SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/../../../../../devel/setup.bash

#####################################
#                                   #
# Single sequence visual & metrics  #
#                                   #
#####################################

rosrun ov_eval plot_trajectories posyaw \
    ${SCRIPT_DIR}/../../../ov_data/uzhfpv_indoor/indoor_forward_6_snapdragon_with_gt.txt \
    ${SCRIPT_DIR}/uzhfpv/algorithms/Mono-KLT/indoor_forward_6_snapdragon_with_gt/KLT.txt \
    ${SCRIPT_DIR}/uzhfpv/algorithms/Mono-NN/indoor_forward_6_snapdragon_with_gt/NN.txt \
    ${SCRIPT_DIR}/uzhfpv/algorithms/Mono-ORB/indoor_forward_6_snapdragon_with_gt/ORB.txt \

rosrun ov_eval error_dataset posyaw \
    ${SCRIPT_DIR}/../../../ov_data/uzhfpv_indoor/indoor_forward_6_snapdragon_with_gt.txt \
    ${SCRIPT_DIR}/uzhfpv/algorithms/ \

#####################################

rosrun ov_eval plot_trajectories posyaw \
    ${SCRIPT_DIR}/../../../ov_data/uzhfpv_indoor/indoor_forward_7_snapdragon_with_gt.txt \
    ${SCRIPT_DIR}/uzhfpv/algorithms/Mono-KLT/indoor_forward_7_snapdragon_with_gt/KLT.txt \
    # ${SCRIPT_DIR}/uzhfpv/algorithms/Mono-NN/indoor_forward_7_snapdragon_with_gt/NN.txt \
    # ${SCRIPT_DIR}/uzhfpv/algorithms/Mono-ORB/indoor_forward_7_snapdragon_with_gt/ORB.txt \

rosrun ov_eval error_dataset posyaw \
    ${SCRIPT_DIR}/../../../ov_data/uzhfpv_indoor/indoor_forward_7_snapdragon_with_gt.txt \
    ${SCRIPT_DIR}/uzhfpv/algorithms/ \

#####################################

rosrun ov_eval plot_trajectories posyaw \
    ${SCRIPT_DIR}/../../../ov_data/uzhfpv_indoor_45/indoor_45_2_snapdragon_with_gt.txt \
    ${SCRIPT_DIR}/uzhfpv/algorithms/Mono-KLT/indoor_45_2_snapdragon_with_gt/KLT.txt \
    ${SCRIPT_DIR}/uzhfpv/algorithms/Mono-NN/indoor_45_2_snapdragon_with_gt/NN.txt \
    ${SCRIPT_DIR}/uzhfpv/algorithms/Mono-ORB/indoor_45_2_snapdragon_with_gt/ORB.txt \

rosrun ov_eval error_dataset posyaw \
    ${SCRIPT_DIR}/../../../ov_data/uzhfpv_indoor_45/indoor_45_2_snapdragon_with_gt.txt \
    ${SCRIPT_DIR}/uzhfpv/algorithms/ \

#####################################

rosrun ov_eval plot_trajectories posyaw \
    ${SCRIPT_DIR}/../../../ov_data/uzhfpv_indoor_45/indoor_45_13_snapdragon_with_gt.txt \
    ${SCRIPT_DIR}/uzhfpv/algorithms/Mono-KLT/indoor_45_13_snapdragon_with_gt/KLT.txt \
    ${SCRIPT_DIR}/uzhfpv/algorithms/Mono-NN/indoor_45_13_snapdragon_with_gt/NN.txt \
    ${SCRIPT_DIR}/uzhfpv/algorithms/Mono-ORB/indoor_45_13_snapdragon_with_gt/ORB.txt \

rosrun ov_eval error_dataset posyaw \
    ${SCRIPT_DIR}/../../../ov_data/uzhfpv_indoor_45/indoor_45_13_snapdragon_with_gt.txt \
    ${SCRIPT_DIR}/uzhfpv/algorithms/ \


#####################################

rosrun ov_eval plot_trajectories posyaw \
    ${SCRIPT_DIR}/../../../ov_data/uzhfpv_indoor_45/indoor_45_14_snapdragon_with_gt.txt \
    ${SCRIPT_DIR}/uzhfpv/algorithms/Mono-KLT/indoor_45_14_snapdragon_with_gt/KLT.txt \
    ${SCRIPT_DIR}/uzhfpv/algorithms/Mono-NN/indoor_45_14_snapdragon_with_gt/NN.txt \
    ${SCRIPT_DIR}/uzhfpv/algorithms/Mono-ORB/indoor_45_14_snapdragon_with_gt/ORB.txt \

rosrun ov_eval error_dataset posyaw \
    ${SCRIPT_DIR}/../../../ov_data/uzhfpv_indoor_45/indoor_45_14_snapdragon_with_gt.txt \
    ${SCRIPT_DIR}/uzhfpv/algorithms/ \