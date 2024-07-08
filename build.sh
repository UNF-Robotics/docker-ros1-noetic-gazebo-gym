#!/bin/sh

# download and prepare sources
mkdir -vp /opt/ros_ws/src
cd /opt/ros_ws/src
wget -q https://github.com/rickstaa/ros-gazebo-gym/archive/refs/heads/noetic.zip
unzip -q noetic.zip
mv -v ros-gazebo-gym-noetic ros-gazebo-gym
rm -r noetic.zip

# examples
wget -q https://github.com/rickstaa/ros-gazebo-gym-examples/archive/refs/heads/noetic.zip
unzip -q noetic.zip
mv -v ros-gazebo-gym-examples-noetic ros-gazebo-gym-examples
rm -r noetic.zip
sed -i -e '/franka/d' \
	ros-gazebo-gym-examples/package.xml \
	ros-gazebo-gym-examples/package.json \
	ros-gazebo-gym-examples/CITATION.cff

# install missing files
echo 'install(
    DIRECTORY config launch
    DESTINATION share/${PROJECT_NAME}
)
install(
    PROGRAMS scripts/start_panda_training_sac_example.py
    DESTINATION lib/${PROJECT_NAME}
)' >> src/ros-gazebo-gym-examples/CMakeLists.txt

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
