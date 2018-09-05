#!/bin/bash
# run tor browser in docker container
mkdir /tmp/Downloads
chmod 777 /tmp/Downloads
echo "Download files to: /home/anon/Dowloads"
echo "Path to downloads on local: /tmp/Downloads"
xhost +local: 
docker run -i -t --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro -v /tmp/Downloads:/home/anon/Downloads paulczar/torbrowser
