# Source this file at the end of your .bashrc on the lab machines

source /opt/ros/indigo/setup.bash
source ~/catkin_ws/devel/setup.bash # Change this to point to your catkin_ws.
export ROS_HOSTNAME=localhost # Optional, the name of this computer.
export ROS_MASTER_HOST=localhost # Used to inform us what robot we're connected to.
export ROS_MASTER_URI=http://localhost:11311 # The location of the ROS master.
export ROBOT=sim # The type of robot.
export ROSCONSOLE_FORMAT='${node} ${function}:${line}: ${message}' # Formats log messages, see http://wiki.ros.org/rosconsole#Console_Output_Formatting

# Get IP address on ethernet
# If you're on a laptop, change eth0 to wlan0
function my_ip() {
    MY_IP=$(/sbin/ifconfig eth0 | awk '/inet/ { print $2 } ' | sed -e s/addr://)
    echo ${MY_IP:-"Not connected"}
}

# Terminal prompt formatting.
# Makes your terminal look like [host (c1) ~/dir], in purple.
# Search for "bash ps1" online to learn more.
PS1='\[\e[1;35m\][\h \w ($ROS_MASTER_HOST)]$ \[\e[m\]'

function setrobot() {
  if [[ "$1" == "sim" ]]; then
    export ROS_HOSTNAME=localhost;
    export ROS_MASTER_HOST=localhost;
    export ROS_MASTER_URI=http://localhost:11311;
    export ROBOT=sim;
  elif [[ "$1" == "panang" ]]; then
    unset ROBOT;
    unset ROS_HOSTNAME;
    export ROS_MASTER_HOST=$1;
    export ROS_MASTER_URI=http://$1.hcrlab.cs.washington.edu:11311;
    export ROS_IP=`my_ip`;
  else
    unset ROBOT;
    unset ROS_HOSTNAME;
    export ROS_MASTER_HOST=$1;
    export ROS_MASTER_URI=http://$1.cs.washington.edu:11311;
    export ROS_IP=`my_ip`;
  fi
}

# Run this from the root of your catkin_ws to run rosdep update.
function getdeps() {
  rosdep install --from-paths src --ignore-src --rosdistro=$ROS_DISTRO -y
}

# Call this once you've sourced your workspace
function set_fetch_blacklist() {
  catkin build config --blacklist gizmo_description hcrl_kuri_launch kuri_camera kuri_gazebo madmux mobile_base_driver 
}

# Call this once you've sourced your workspace
function set_kuri_blacklist() {
  catkin build config --blacklist kuri_camera
}

