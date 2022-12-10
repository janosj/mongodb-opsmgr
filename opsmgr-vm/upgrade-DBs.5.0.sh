#!/bin/bash

# Ops Manager requires a minimum version of MongoDB for the backing databases.
# e.g. OM 6 requires 4.4 minimum. 

# Search on “Upgrade a Standalone to 5.0” (replace with desired version)
# https://www.mongodb.com/docs/manual/release-notes/5.0-upgrade-standalone

if [[ $EUID -ne 0 ]]; then
  echo "ERROR: Please run script with sudo"
  echo
  exit 1
fi

OLD_FCV=4.4
# Need to also manually set this in two places below, "Setting New FCV to ... "
NEW_FCV=5.0

# Comes from here (Install a specific release of MongoDB): 
# https://www.mongodb.com/docs/v5.0/tutorial/install-mongodb-on-ubuntu/#install-the-mongodb-packages
DB_VER=5.0.14

echo "Check existing DB version (mongo, mongo --port 27018)"
echo "Check FCV in each (must be $OLD_FCV):"
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

echo "Importing public key [$NEW_FCV]..."
wget -qO - https://www.mongodb.org/static/pgp/server-$NEW_FCV.asc | apt-key add -

echo
read -p "Press enter to continue."
echo

echo "Creating list file [$NEW_FCV]..."
echo "deb [ arch=amd64,arm64,s390x ] http://repo.mongodb.com/apt/ubuntu bionic/mongodb-enterprise/$NEW_FCV multiverse" | tee /etc/apt/sources.list.d/mongodb-enterprise.list

echo
read -p "Press enter to continue. To verify: vi /etc/apt/sources.list.d/mongodb-enterprise.list"
echo

echo "Reloading local package database..."
apt-get update

echo
read -p "Press enter to continue."
echo

echo "Upgrading MDB binaries..."
sudo apt-get install -y mongodb-enterprise=$DB_VER mongodb-enterprise-server=$DB_VER mongodb-enterprise-shell=$DB_VER mongodb-enterprise-mongos=$DB_VER mongodb-enterprise-tools=$DB_VER mongodb-enterprise-database-tools-extra=$DB_VER

sudo apt autoremove -y

echo
read -p "Press enter to continue."
echo

echo "Restarting 27017..."
service mongod start

echo
read -p "Press enter to continue."
echo

echo "Setting FCV to $NEW_FCV..."
mongo "localhost:27017/admin" --eval 'db.adminCommand({setFeatureCompatibilityVersion:"5.0"})'

echo
read -p "Press enter to continue."
echo

echo "Restarting 27018..."
service mongod2 start

echo
read -p "Press enter to continue."
echo

echo "Setting FCV to $NEW_FCV..."
mongo "localhost:27018/admin" --eval 'db.adminCommand({setFeatureCompatibilityVersion:"5.0"})'

echo
read -p "Press enter to continue."
echo

echo "Restarting Ops Manager..."
rm /opt/mongodb/mms/logs/*
service mongodb-mms start

echo
echo "Monitor https://opsmgr:8443 for server UP, or /opt/mongodb/mms/logs/mms0.log"
read -p "Press enter to continue."
echo


