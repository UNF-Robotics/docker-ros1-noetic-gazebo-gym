#!/bin/sh

# download and prepare sources
mkdir -vp /opt/ros_ws/src
cd /opt/ros_ws/src
wget -q https://github.com/ammar-n-abbas/sim2real-ur-gym-gazebo/archive/refs/heads/master.zip
unzip -q master.zip
mv -v sim2real-ur-gym-gazebo-master/* ./
rm -r master.zip ur_openai_gym

# update ur_openai
wget -q https://github.com/cambel/ur_openai_gym/archive/refs/heads/main.zip
unzip -q main.zip
rm main.zip

# set ROS env
. /opt/ros/noetic/setup.sh

# install dependencies
cd /opt/ros_ws
rosdep init
rosdep update
rosdep fix-permissions
apt-get update
rosdep install --from-paths src --ignore-src -r -y

# correct depend
sed -i -e "s|^ DEPENDS gazebo| DEPENDS GAZEBO|" \
	src/gazebo-pkgs/gazebo_grasp_plugin_ros/CMakeLists.txt \
	src/gazebo-pkgs/gazebo_grasp_plugin/CMakeLists.txt \
	src/gazebo-pkgs/gazebo_version_helpers/CMakeLists.txt

# build
catkin build
