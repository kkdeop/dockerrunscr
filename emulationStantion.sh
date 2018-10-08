#!/bin/bash
#run emulation stantion
xhost +local: 
docker run -it --rm \
                -e DBUS_SESSION_BUS_ADDRESS \
                -e DISPLAY \
                --device /dev/input \
                --device /dev/snd \
                -v $HOME/.emulationstation:/root/.emulationstation \
                -v $HOME/roms:/root/roms \
                -v /run/user/$(id -u):/run/user/$(id -u) \
                -v /tmp/.X11-unix/:/tmp/.X11-unix/ \
                -v /var/run/dbus:/var/run/dbus \
                -v /var/run/docker.sock:/var/run/docker.sock \
                somatorio/emulationstation
