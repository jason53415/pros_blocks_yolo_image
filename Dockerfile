FROM ghcr.io/otischung/pros_ai_image:1.3.6
ENV ROS2_WS=/workspaces
ENV ROS_DOMAIN_ID=1
ENV ROS_DISTRO=humble
ARG THREADS=4
ARG TARGETPLATFORM

##### Copy Source Code #####
COPY . /tmp

##### Environment Settings #####
WORKDIR ${ROS2_WS}

##### colcon Installation #####
# Copy source code
RUN mv /tmp/src/yolov8 ${ROS2_WS}/src/yolov8 && \
### YOLOv8 Installation ###
    pip3 install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu && \    
    pip3 install --no-cache-dir ncnn ultralytics typing-extensions opencv-python && \    
    source /opt/ros/humble/setup.bash && \
    colcon build --packages-select yolov8_msgs --symlink-install && \
    colcon build --packages-select yolov8_ros --symlink-install && \
    colcon build --packages-select yolov8_bringup --symlink-install && \
##### Post-Settings #####
# Clear tmp and cache
    rm -rf /tmp/* && \
    rm -rf /temp/* && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/ros_entrypoint.bash"]
CMD ["bash", "-l"]
