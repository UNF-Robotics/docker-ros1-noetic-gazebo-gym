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
	ros-noetic-ur-description \
	unzip \
	&& rm -rf /var/lib/apt/lists/*

#	catkin-lint \
#	ros-noetic-control-msgs \

# install gymnasium
RUN pip install gymnasium

# copy and run build script vs many RUN commands
COPY build.sh ./build.sh

RUN chmod +x ./build.sh && \
    sync && \
    ./build.sh
