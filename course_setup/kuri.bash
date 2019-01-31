# Source this file at the end of the bashrc on your robot
export ROBOT_NAME=$(hostname)

export ROS_HOSTNAME=${ROBOT_NAME}.hcrlab.cs.washington.edu

source /opt/gizmo/setup.bash

function set_blacklist() {
  # We want to use the real versions that are available on the robot, not our stubs
  catkin_make --force-cmake -DCATKIN_BLACKLIST_PACKAGES="madmux;mobile_base_driver;kuri_gazebo"
}
