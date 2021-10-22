if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo
echo Stopping Ops Manager service...
service mongodb-mms stop

echo
echo Removing Ops Manager...
yum erase -y mongodb-mms

echo
echo Shutting down backup DB...
mongo --port 27018 --eval "
  use admin;
  db.shutdownServer();
"

echo
echo Shutting down AppDB...
mongo --port 27017 --eval "
  use admin;
  db.shutdownServer();
"

echo
echo Removing MongoDB database files...
rm -rf /data/*

echo
echo Removing OpsMgr installation files...
rm -rf /opt/mongodb

echo Removing log files...
rm -rf /var/log/mongodb
  
echo
echo Ops Manager removed.

