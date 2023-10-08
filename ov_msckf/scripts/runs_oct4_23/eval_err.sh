SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/../../../../../devel/setup.bash

#####################################
#                                   #
# Single sequence visual & metrics  #
#                                   #
#####################################

rosrun ov_eval plot_trajectories posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/V1_01_easy.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-KLT/V1_01_easy/KLT.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-NN/V1_01_easy/NN.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-ORB/V1_01_easy/ORB.txt \

rosrun ov_eval error_dataset posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/V1_01_easy.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/ \

#####################################

rosrun ov_eval plot_trajectories posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/V1_02_medium.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-KLT/V1_02_medium/KLT.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-NN/V1_02_medium/NN.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-ORB/V1_02_medium/ORB.txt \

rosrun ov_eval error_dataset posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/V1_02_medium.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/ \

#####################################

rosrun ov_eval plot_trajectories posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/V1_03_difficult.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-KLT/V1_03_difficult/KLT.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-NN/V1_03_difficult/NN.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-ORB/V1_03_difficult/ORB.txt \

rosrun ov_eval error_dataset posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/V1_03_difficult.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/ \

#####################################

rosrun ov_eval plot_trajectories posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/V2_01_easy.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-KLT/V2_01_easy/KLT.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-NN/V2_01_easy/NN.txt \
    # ORB failed ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-ORB/V2_01_easy/ORB.txt \

rosrun ov_eval error_dataset posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/V2_01_easy.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/ \

#####################################

rosrun ov_eval plot_trajectories posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/V2_02_medium.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-KLT/V2_02_medium/KLT.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-NN/V2_02_medium/NN.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-ORB/V2_02_medium/ORB.txt \

rosrun ov_eval error_dataset posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/V2_02_medium.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/ \

#####################################

rosrun ov_eval plot_trajectories posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/V2_03_difficult.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-KLT/V2_03_difficult/KLT.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-NN/V2_03_difficult/NN.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-ORB/V2_03_difficult/ORB.txt \

rosrun ov_eval error_dataset posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/V2_03_difficult.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/ \

#####################################

rosrun ov_eval plot_trajectories posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/MH_01_easy.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-KLT/MH_01_easy/KLT.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-NN/MH_01_easy/NN.txt \
    # ORB failed ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-ORB/MH_01_easy/ORB.txt \

rosrun ov_eval error_dataset posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/MH_01_easy.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/ \

#####################################

rosrun ov_eval plot_trajectories posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/MH_02_easy.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-KLT/MH_02_easy/KLT.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-NN/MH_02_easy/NN.txt \
    # ORB failed ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-ORB/MH_02_easy/ORB.txt \

rosrun ov_eval error_dataset posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/MH_02_easy.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/ \

#####################################

rosrun ov_eval plot_trajectories posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/MH_03_medium.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-KLT/MH_03_medium/KLT.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-NN/MH_03_medium/NN.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-ORB/MH_03_medium/ORB.txt \

rosrun ov_eval error_dataset posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/MH_03_medium.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/ \

#####################################

rosrun ov_eval plot_trajectories posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/MH_04_difficult.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-KLT/MH_04_difficult/KLT.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-NN/MH_04_difficult/NN.txt \
    # ORB failed ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-ORB/MH_04_difficult/ORB.txt \

rosrun ov_eval error_dataset posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/MH_04_difficult.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/ \

#####################################

rosrun ov_eval plot_trajectories posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/MH_05_difficult.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-KLT/MH_05_difficult/KLT.txt \
    # NN failed ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-NN/MH_05_difficult/NN.txt \
    # ORB failed ${SCRIPT_DIR}/exp_euroc/algorithms/Mono-ORB/MH_05_difficult/ORB.txt \

rosrun ov_eval error_dataset posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/MH_05_difficult.txt \
    ${SCRIPT_DIR}/exp_euroc/algorithms/ \

#####################################
#                                   #
#      Error metrics comparison     #
#                                   #
#####################################

rosrun ov_eval error_comparison posyaw \
    ${SCRIPT_DIR}/../../../ov_data/euroc_mav/ \
    ${SCRIPT_DIR}/exp_euroc/algorithms_filtered/
