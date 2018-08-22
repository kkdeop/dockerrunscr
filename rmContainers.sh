#!/bin/bash
# remove all containers 
# pass -f to force remove
docker rm $1 $(docker ps -q -a)