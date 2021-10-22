#!/bin/bash
# Convenience script to ssh into Docker containers
# Run this script using 'sudo'

echo 

if [[ $EUID -ne 0 ]]; then
  echo "ERROR: Please run script with sudo"
  echo 
  exit 1
fi

CNUM=$1
if [[ -z "$CNUM" ]]; then
  CNUM=1
fi

docker exec -it automation-agent-container$CNUM /bin/bash
