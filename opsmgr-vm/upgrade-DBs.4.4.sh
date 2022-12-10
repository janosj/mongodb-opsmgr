#!/bin/bash

# Ops Manager requires a minimum version of MongoDB for the backing databases.
# e.g. OM 6 requires 4.4 minimum. 

# Search on “Upgrade a Standalone to 4.4” (replace with desired version)
# https://www.mongodb.com/docs/manual/release-notes/4.4-upgrade-standalone/ 

if [[ $EUID -ne 0 ]]; then
  echo "ERROR: Please run script with sudo"
  echo
  exit 1
fi

echo "Check existing DB version (mongo, mongo --port 27018)"
echo "Check FCV in each:"
echo "db.adminCommand( { getParameter: 1, featureCompatibilityVersion: 1 } )"

echo
read -p "Press enter to continue."
echo

# The backing databases were installed using the Ubuntu Package Manager (apt-get):
#   sudo apt-get install -y mongodb-enterprise

echo "Shutting down Ops Manager..."
service mongodb-mms stop

echo
read -p "Press enter to continue. To verify: ps -ef | grep mongo"
echo

echo "Shutting down port 27018..."
mongo "localhost:27018/admin" --eval 'db.adminCommand({"shutdown":1})'

echo
echo "An error there indicates a shutdown."
read -p "Press enter to continue."
echo

echo "Shutting down port 27017..."
mongo "localhost:27017/admin" --eval 'db.adminCommand({"shutdown":1})'

echo
echo "An error there indicates a shutdown."
read -p "Press enter to continue."
echo

echo "Importing public key [4.4]..."
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -

echo
read -p "Press enter to continue."
echo

echo "Creating list file [4.4]..."
echo "deb [ arch=amd64,arm64,s390x ] http://repo.mongodb.com/apt/ubuntu bionic/mongodb-enterprise/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-enterprise.list

echo
read -p "Press enter to continue. To verify: vi /etc/apt/sources.list.d/mongodb-enterprise.list"
echo

echo "Reloading local package database..."
apt-get update

echo
read -p "Press enter to continue."
echo

echo "Upgrading MDB binaries..."
# This will install the latest release in the series (e.g. 4.4.x):
sudo apt-get install -y mongodb-enterprise=4.4.18 mongodb-enterprise-server=4.4.18 mongodb-enterprise-shell=4.4.18 mongodb-enterprise-mongos=4.4.18 mongodb-enterprise-tools=4.4.18 mongodb-enterprise-database-tools-extra=4.4.18

sudo apt autoremove -y

echo
read -p "Press enter to continue."
echo

echo "Restarting 27017..."
service mongod start

echo
read -p "Press enter to continue."
echo

echo "Setting FCV to 4.4..."
mongo "localhost:27017/admin" --eval 'db.adminCommand({setFeatureCompatibilityVersion:"4.4"})'

echo
read -p "Press enter to continue."
echo

echo "Restarting 27018..."
service mongod2 start

echo
read -p "Press enter to continue."
echo

echo "Setting FCV to 4.4..."
mongo "localhost:27018/admin" --eval 'db.adminCommand({setFeatureCompatibilityVersion:"4.4"})'

echo
read -p "Press enter to continue."
echo

echo "Restarting Ops Manager..."
rm /opt/mongodb/mms/logs/*
service mongodb-mms start

echo
echo "Monitor https://opsmgr:8443 for server UP, or /opt/mongodb/mms/logs"
read -p "Press enter to continue."
echo


