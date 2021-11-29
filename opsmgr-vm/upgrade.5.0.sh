#!/bin/bash

# Review upgrade doc here: https://docs.opsmanager.mongodb.com/current/tutorial/upgrade-ops-manager/

if [[ $EUID -ne 0 ]]; then
  echo "ERROR: Please run script with sudo"
  echo
  exit 1
fi

echo "Stopping any running Docker containers..."
./stop_containers.sh

echo "Shutting down Ops Manager..."
service mongodb-mms stop

echo "Reclaiming space..."
./reclaim-space.sh

echo "Remember to clear up /etc/hosts..."
# To Do: clear up /etc/hosts

echo "Preserving old config files..."
cp /opt/mongodb/mms/conf/conf-mms.properties /opt/mongodb/mms/conf/conf-mms.properties.4.4.12
cp /etc/mongodb-mms/gen.key /etc/mongodb-mms/gen.key.4.4.12

echo "Downloading Ops Manager binary..."
omFile=mongodb-mms_5.0.4.100.20211103T1316Z-1_x86_64.deb
downloadFolder=~/downloads
if [[ ! -d $downloadFolder ]]; then
    mkdir $downloadFolder
fi
if [ ! -f $downloadFolder/$omFile ]; then
    curl -o $downloadFolder/$omFile https://downloads.mongodb.com/on-prem-mms/deb/$omFile 
else
    echo "  .. already downloaded."
fi

echo "Installing new OM package..."
dpkg -i $downloadFolder/$omFile

# Update get_versions.sh to include 100.3.1 or later of Tools (as required by OM 5)

echo "Starting Ops Manager..."
sudo service mongodb-mms start

