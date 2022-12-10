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

# Cleanup the image

echo "Reclaiming space..."
./reclaim-space.sh

echo "Clearing up /etc/hosts..."
sed -i '/myserver/d' /etc/hosts

# End image cleanup

echo "Preserving old config files..."
# conf-mms.properties uses two additional lines to support local mode (added subsequently)
cp /opt/mongodb/mms/conf/conf-mms.properties /opt/mongodb/mms/conf/conf-mms.properties.4.4.12
# This changes from version to version, but it's not customized here
cp /opt/mongodb/mms/conf/mms.conf /opt/mongodb/mms/conf/mms.conf.4.4.12
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

echo "Installing new OM package... Selet Y to overwrite existing files."
dpkg -i $downloadFolder/$omFile

echo "Restoring local mode modifications in conf-mms.properties..."
cat <<EOT >> /opt/mongodb/mms/conf/conf-mms.properties
automation.versions.source=local
automation.versions.directory=/opt/mongodb/mms/mongodb-releases/
EOT

echo "Starting Ops Manager..."
sudo service mongodb-mms start

# Update get_versions.sh to include 100.3.1 or later of Tools (as required by OM 5)
./get_versions.sh

