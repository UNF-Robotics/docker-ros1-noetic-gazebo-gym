FROM ros:noetic-ros-core-focal

# update base system
RUN apt-get update && apt-get upgrade -y --no-install-recommends

# install gazebo & rviz2 packages
RUN apt-get install -y --no-install-recommends \
	nano \
	pip \
	psmisc \
	python3-catkin-tools \
	python3-catkin \
	python3-psutil \
	ros-dev-tools \
	ros-noetic-gazebo-ros \
	ros-noetic-rviz \
	ros-noetic-rviz-visual-tools \
	unzip \
	&& rm -rf /var/lib/apt/lists/*

# install python packages
RUN pip install --no-cache-dir gymnasium numpy==1.23.1 stable_baselines3 torch

# copy and run build script vs many RUN commands
COPY build.sh ./build.sh

RUN chmod +x ./build.sh && \
    sync && \
    ./build.sh
