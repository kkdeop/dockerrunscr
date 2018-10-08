#!/bin/bash
#run retroArch
#set joypad driver to linux raw
docker run -it --rm \
	-e DISPLAY \
	-v /tmp/.X11-unix/:/tmp/.X11-unix/ \
	-v $HOME/.config/retroarch:/root/.config/retroarch \
	-v $HOME/retroarch/roms:/root/roms \
	--privileged -v /dev/bus/usb:/dev/bus/usb \
	retroarch 
