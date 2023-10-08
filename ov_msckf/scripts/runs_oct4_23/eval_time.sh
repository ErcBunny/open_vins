SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/../../../../../devel/setup.bash

bagnames=(
  "V1_01_easy"
  "V1_02_medium"
  "V1_03_difficult"
  "V2_01_easy"
  "V2_02_medium"
  "V2_03_difficult"
  "MH_01_easy"
  "MH_02_easy"
  "MH_03_medium"
  "MH_04_difficult"
  "MH_05_difficult"
)

for i in "${!bagnames[@]}"; do

echo "================================= ${bagnames[i]} ========================================="

echo "---------------- KLT ----------------"
rosrun ov_eval timing_flamegraph \
    ${SCRIPT_DIR}/exp_euroc/timings/Mono-KLT/${bagnames[i]}/KLT.txt

echo "---------------- NN ----------------"
rosrun ov_eval timing_flamegraph \
    ${SCRIPT_DIR}/exp_euroc/timings/Mono-NN/${bagnames[i]}/NN.txt

echo "---------------- ORB ----------------"
rosrun ov_eval timing_flamegraph \
    ${SCRIPT_DIR}/exp_euroc/timings/Mono-ORB/${bagnames[i]}/ORB.txt

done
