#!/bin/bash

# Review upgrade doc here: https://www.mongodb.com/docs/ops-manager/v6.0/tutorial/upgrade-ops-manager/
# Need to upgrade to latest 5.x release, then to latest 6.x release.



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
cp /opt/mongodb/mms/conf/conf-mms.properties /opt/mongodb/mms/conf/conf-mms.properties.5.x.preserve
# This changes from version to version, but it's not customized here
cp /opt/mongodb/mms/conf/mms.conf /opt/mongodb/mms/conf/mms.conf.5.x.preserve
cp /etc/mongodb-mms/gen.key /etc/mongodb-mms/gen.key.5.x.preserve

echo "Downloading Ops Manager binary..."
omFile=mongodb-mms_5.0.17.100.20221115T1044Z-1_x86_64.deb
downloadFolder=~/downloads
if [[ ! -d $downloadFolder ]]; then
    mkdir $downloadFolder
fi
if [ ! -f $downloadFolder/$omFile ]; then
    curl -o $downloadFolder/$omFile https://downloads.mongodb.com/on-prem-mms/deb/$omFile 
else
    echo "  .. already downloaded."
fi

echo "Installing new OM package... Select Y to overwrite existing files."
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

echo "Upgrade complete!"
echo "New version is running."
echo "Review /opt/mongodb/mms/conf/conf-mms.properties and mms.conf for changes."
echo "Update all agents manually. Login to instance and click Update All Agents."

