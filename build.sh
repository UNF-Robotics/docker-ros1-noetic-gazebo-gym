#!/bin/sh

# download and prepare sources
mkdir -vp /opt/ros_ws/src
cd /opt/ros_ws/src
wget -q https://github.com/rickstaa/ros-gazebo-gym/archive/refs/heads/noetic.zip
unzip -q noetic.zip
mv -v ros-gazebo-gym-noetic ros-gazebo-gym
rm -r noetic.zip

# set ROS env
. /opt/ros/noetic/setup.sh

# prevent keyboard config
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# install dependencies
cd /opt/ros_ws
rosdep init
rosdep update
rosdep fix-permissions
apt-get update
rosdep install --from-paths src --ignore-src -r -y

# build and install
catkin config --install
catkin build
