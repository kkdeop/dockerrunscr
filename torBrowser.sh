#!/bin/bash
# run tor browser in docker container
xhost +local: 
docker run -d -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix paulczar/torbrowser
