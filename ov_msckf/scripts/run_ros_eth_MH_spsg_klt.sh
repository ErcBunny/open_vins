#!/usr/bin/env bash

# Source our workspace directory to load ENV variables
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/../../../../devel/setup.bash

#=============================================================
#=============================================================
#=============================================================

# estimator configurations
modes=(
  "mono"
)

# dataset locations
bagnames=(
  # "V1_01_easy"
  # "V1_02_medium"
  # "V1_03_difficult"
  # "V2_01_easy"
  # "V2_02_medium"
  # "V2_03_difficult"
  "MH_01_easy"
  "MH_02_easy"
  "MH_03_medium"
  "MH_04_difficult"
  "MH_05_difficult"
)

# how far we should start into the dataset
# this can be used to skip the initial sections
bagstarttimes=(
  "0"
  "0"
  "0"
  "0"
  "0"
  "0"
  "40"
  "35"
  "5"
  "10"
  "5" # stereo can fail if starts while still due to bad left-right KLT....
)

# location to save log files into
save_path1="${SCRIPT_DIR}/runs/exp_euroc/algorithms/"
save_path2="${SCRIPT_DIR}/runs/exp_euroc/timings/"
bag_path="${SCRIPT_DIR}/datasets/euroc_mav/"
ov_ver="2.7_spsg_klt"


#=============================================================
#=============================================================
#=============================================================

big_start_time="$(date -u +%s)"

# Loop through all datasets
for i in "${!bagnames[@]}"; do
# Loop through all modes
for h in "${!modes[@]}"; do

# Monte Carlo runs for this dataset
# If you want more runs, change the below loop
for j in {00..00}; do

# start timing
start_time="$(date -u +%s)"
filename_est="$save_path1/ov_${ov_ver}_${modes[h]}/${bagnames[i]}/${j}_estimate.txt"
filename_time="$save_path2/ov_${ov_ver}_${modes[h]}/${bagnames[i]}/${j}_timing.txt"

# number of cameras
if [ "${modes[h]}" == "mono" ]
then
  temp1="1"
  temp2="false"
fi
if [ "${modes[h]}" == "binocular" ]
then
  temp1="2"
  temp2="false"
fi
if [ "${modes[h]}" == "stereo" ]
then
  temp1="2"
  temp2="true"
fi

# run our ROS launch file (note we send console output to terminator)
# subscribe=live pub, serial=read from bag (fast)
roslaunch ov_msckf serial.launch \
  use_klt:="true" \
  num_pts:="500" \
  init_imu_thresh:="1" \
  init_max_disparity:="7.5" \
  init_dyn_use:="true" \
  max_cameras:="$temp1" \
  use_stereo:="$temp2" \
  config:="euroc_mav" \
  dataset:="${bagnames[i]}" \
  bag:="$bag_path/${bagnames[i]}.bag" \
  bag_start:="${bagstarttimes[i]}" \
  dobag:="true" \
  dosave:="true" \
  path_est:="$filename_est" \
  dotime:="true" \
  dolivetraj:="true" \
  dorviz:="true" \
  path_time:="$filename_time" &> /dev/null

# print out the time elapsed
end_time="$(date -u +%s)"
elapsed="$(($end_time-$start_time))"
echo "BASH: ${modes[h]} - ${bagnames[i]} - run $j took $elapsed seconds";

done


done
done




# print out the time elapsed
big_end_time="$(date -u +%s)"
big_elapsed="$(($big_end_time-$big_start_time))"
echo "BASH: script took $big_elapsed seconds in total!!";



