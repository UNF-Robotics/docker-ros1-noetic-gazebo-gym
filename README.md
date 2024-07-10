# docker-ros1-noetic-gazebo-gym
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg?style=plastic)](https://github.com/UNF-Robotics/docker-ros1-noetic-gazebo-gym/blob/master/LICENSE.txt)
[![Docker Image Status](https://github.com/UNF-Robotics/docker-ros1-noetic-gazebo-gym/actions/workflows/main.yml/badge.svg/)](https://github.com/UNF-Robotics/docker-ros1-noetic-gazebo-gym/actions)

Docker image with ROS 1 Noetic Development Environment with Gazebo, Gymnasium, 
and RViz for various robotics purposes at UNF, club, research, and development.
This container contains the initial environment to build and run ROS 1
simulations using Gazebo, Gymnasium, PyTorch, and RViz.

This container has a pre-built installation of [ros-gazebo-gym](https://github.com/rickstaa/ros-gazebo-gym)
along with [panda_gazebo](https://github.com/rickstaa/panda-gazebo/)
for complete simulation and reinforcement Learning development environment,
with sources in `/opt/ros_ws/src`.

[Latest](https://hub.docker.com/r/unfrobotics/docker-ros1-noetic-gazebo-gym/tags)

## Docker Pull Command
```bash
docker pull unfrobotics/docker-ros1-noetic-gazebo-gym:latest
```

## enable X11 ssh forwarding
Enable in sshd and restart
```
sudo nano /etc/ssh/sshd_config

X11Forwarding yes
```

Enable X server access
```bash
sudo xhost +local:docker
sudo xhost +
```
## Development Environment Usage
Inside the container, there is an initial folder `/opt/ros_ws/src`
that is intended for use for to build ROS packages. ROS package sources can
either be downloaded into the container, or local mount, to allow for
development using a local IDE.

### Run Command on Linux
The following command will open a terminal to the newly created 
container that uses the host computers network. It also assumes that the
sources have been downloaded locally in `~/mypkg_ros/` and shared as a
volume in the folder inside the container. Inside the container run `gazebo`
or `rviz`, attach another shell to run both and/or other ROS commands.
```bash
docker run --net=host --rm -it --env DISPLAY=$DISPLAY --privileged \
    -v /dev:/dev -v ~/mypkg_ros/:/opt/ros_ws/src/mypkg_ros \
    unfrobotics/docker-ros1-noetic-gazebo-gym:latest
```

### Start sample world
Run the following command to start a sample world, arm with empty world
```bash
roslaunch panda_gazebo start_simulation.launch
```
