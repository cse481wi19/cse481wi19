# Source this file at the end of the bashrc on your robot
export ROBOT_NAME=$(hostname)

export ROS_HOSTNAME=${ROBOT_NAME}.cs.washington.edu

# Call this once you've sourced your on-robot workspace
function set_blacklist() {
  catkin build config --blacklist gizmo_description hcrl_kuri_launch kuri_camera kuri_gazebo madmux mobile_base_driver 
}
