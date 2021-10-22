#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "ERROR: Please run script with sudo"
  echo
  exit 1
fi

echo "Ensure Ops Manager is shut down: sudo service mongodb-mms stop" 
read -p "Press enter to acknowledge."

echo Deleting log files from /opt/mongodb/mms/logs...
rm /opt/mongodb/mms/logs/*

echo Reclaiming Docker space...
docker system prune
docker volume prune

echo "Done. Restart Ops Manager: sudo service mongodb-mms start"

