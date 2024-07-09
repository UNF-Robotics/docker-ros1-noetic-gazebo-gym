FROM ros:noetic-ros-core-focal

# update base system
RUN apt-get update && apt-get upgrade -y --no-install-recommends

# install gazebo & rviz2 packages
RUN apt-get install -y --no-install-recommends \
	nano \
	pip \
	psmisc \
	python3-catkin-tools \
	ros-dev-tools \
	ros-noetic-gazebo-ros \
	ros-noetic-rviz \
	unzip \
	&& rm -rf /var/lib/apt/lists/*

# install gymnasium
RUN pip install --no-cache-dir gymnasium torch

# copy and run build script vs many RUN commands
COPY build.sh ./build.sh

RUN chmod +x ./build.sh && \
    sync && \
    ./build.sh
