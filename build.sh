#!/bin/sh

# prepare ros on login
echo 'source "/opt/ros_ws/install/setup.bash"' >> /root/.bashrc

# download and prepare sources
mkdir -vp /opt/ros_ws/src
cd /opt/ros_ws/src
wget -q https://github.com/rickstaa/ros-gazebo-gym/archive/refs/heads/noetic.zip
unzip -q noetic.zip
mv -v ros-gazebo-gym-noetic ros-gazebo-gym
rm -r noetic.zip

wget -q https://github.com/rickstaa/panda-gazebo/archive/refs/heads/noetic.zip
unzip -q noetic.zip
mv -v panda-gazebo-noetic/panda_gazebo ./
rm -r noetic.zip
sed -i -e 's|^    gazebo|    GAZEBO|' \
	-e '/dyn_reconf/d' \
	panda_gazebo/CMakeLists.txt

# install missing files
echo 'install(
    DIRECTORY cfg launch resources
    DESTINATION share/${PROJECT_NAME}
)' >> panda_gazebo/CMakeLists.txt

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

# modify franka_ros
sed -i -e '20i\ \ <arg name="physics"     default="ode"   doc="" />' \
        /opt/ros/noetic/share/franka_gazebo/launch/panda.launch
