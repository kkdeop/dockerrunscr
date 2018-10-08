FROM ubuntu

RUN \
apt-get update && apt-get upgrade -y && apt-get install libretro-*  retroarch -y --no-install-recommends
WORKDIR /root
ENTRYPOINT ["/usr/bin/retroarch"]
