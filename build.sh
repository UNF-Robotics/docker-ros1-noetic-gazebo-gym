#!/bin/sh

# prepare ros on login
echo 'source "/opt/ros_ws/install/setup.bash"' >> /root/.bashrc

# download and prepare sources
mkdir -vp /opt/ros_ws/src
cd /opt/ros_ws/src
wget -q https://github.com/rickstaa/ros-gazebo-gym/archive/refs/heads/noetic.zip
unzip -q noetic.zip
mv -v ros-gazebo-gym-noetic ros-gazebo-gym
rm noetic.zip

wget -q https://github.com/rickstaa/panda-gazebo/archive/refs/heads/noetic.zip
unzip -q noetic.zip
mv -v panda-gazebo-noetic/panda_gazebo ./
rm -r noetic.zip panda-gazebo-noetic

# fix CMakeLists, correct gazebo depend and add generate config _gencfg
sed -i -e 's|^    gazebo|    GAZEBO|' \
	-e 's|DynReconf||' \
	-e 's|EffortControlTest|JointEfforts|' \
	-e 's|PositionControlTest|JointPositions|' \
	-e 's|catkin_EXPORTED_TARGETS}|catkin_EXPORTED_TARGETS} ${PROJECT_NAME}_gencfg|' \
	panda_gazebo/CMakeLists.txt

# enable dynamic reconfigure during build
sed -i -e 's|<!-- <build.*dynamic_reconfigure.*-->|<build_depend>dynamic_reconfigure</build_depend>|' \
       -e 's|<!-- <exec.*dynamic_reconfigure.*-->|<exec_depend>dynamic_reconfigure</exec_depend>|' \
       panda_gazebo/package.xml

# install missing files
echo '
catkin_install_python(PROGRAMS
    nodes/panda_control_server.py
    nodes/panda_moveit_server.py
    scripts/joint_efforts_dynamic_reconfigure_server.py
    scripts/joint_positions_dynamic_reconfigure_server.py
    scripts/set_logging_level.py
    DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)
install(
    DIRECTORY cfg launch resources
    DESTINATION share/${PROJECT_NAME}
)
install(
    TARGETS ${PROJECT_NAME}
    DESTINATION lib/${PROJECT_NAME}
)' >> panda_gazebo/CMakeLists.txt

# strip DynReconf from name, causes header to have same name as file...
cd panda_gazebo/cfg/dyn_reconf
mv -v MoveitServerDynReconf.cfg MoveitServer.cfg
mv -v EffortControlTestDynReconf.cfg JointEfforts.cfg
mv -v PositionControlTestDynReconf.cfg JointPositions.cfg

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

# Copy missing python files..
cp -r src/ros-gazebo-gym/src/ros_gazebo_gym/*  install/lib/python3/dist-packages/ros_gazebo_gym
cp -r src/panda_gazebo/src/panda_gazebo/* install/lib/python3/dist-packages/panda_gazebo/

# modify franka_ros
sed -i -e '20i\ \ <arg name="physics"     default="ode"   doc="" />' \
        /opt/ros/noetic/share/franka_gazebo/launch/panda.launch
