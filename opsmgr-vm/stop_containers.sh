#!/bin/bash
# Run this script using 'sudo' to stop the automation agent containers, e.g.:  > sudo ./stop_containers.sh

echo 

if [[ $EUID -ne 0 ]]; then
  echo "ERROR: Please run script with sudo"
  echo 
  exit 1
fi

docker container stop $(docker container ls -aq)
docker container prune

