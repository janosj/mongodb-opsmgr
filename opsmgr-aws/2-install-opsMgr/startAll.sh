# Installation results in an up-and-running Ops Manager.
# Run this script if you did a server reboot.
# Note that the components have to start in sequence,
# so you can't simply enable the Ops Manager service.

# Start AppDB:
sudo -u mongod mongod --port 27017 --dbpath /data/appdb --logpath /data/appdb/mongodb.log --wiredTigerCacheSizeGB 1 --fork

# Start BackupDB:
sudo -u mongod mongod --port 27018 --dbpath /data/backup --logpath /data/backup/mongodb.log --wiredTigerCacheSizeGB 1 --fork

# Start Ops Manager:
sudo service mongodb-mms start

