#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

DOWNLOAD_FOLDER=/opt/mongodb/mms/mongodb-releases

download_file () {

   local FILENAME=$1
   local BASEURL=$2

   if [ ! -f $DOWNLOAD_FOLDER/$FILENAME ]
   then
     echo "Downloading $FILENAME..."
     curl -o $DOWNLOAD_FOLDER/$FILENAME $BASEURL/$FILENAME
   else
     echo "$FILENAME already downloaded."
   fi

}


# Community
download_file mongodb-linux-x86_64-rhel80-4.2.1.tgz http://downloads.mongodb.org/linux

# Enterprise
# RHEL8
download_file mongodb-linux-x86_64-enterprise-rhel80-6.0.5.tgz https://downloads.mongodb.com/linux
download_file mongodb-linux-x86_64-enterprise-rhel80-6.0.2.tgz https://downloads.mongodb.com/linux
download_file mongodb-linux-x86_64-enterprise-rhel80-5.0.14.tgz https://downloads.mongodb.com/linux
download_file mongodb-linux-x86_64-enterprise-rhel80-5.0.6.tgz https://downloads.mongodb.com/linux
download_file mongodb-linux-x86_64-enterprise-rhel80-4.4.18.tgz https://downloads.mongodb.com/linux
download_file mongodb-linux-x86_64-enterprise-rhel80-4.4.11.tgz https://downloads.mongodb.com/linux

# Get the URL format from download center.
# Get the correct version from Ops Manager, when you CONFIRM before deploying (bottom of screen).  
# Or, see the error message if you try to deploy and it's not there.
wget -P /opt/mongodb/mms/mongodb-releases https://fastdl.mongodb.org/tools/db/mongodb-database-tools-rhel80-x86_64-100.7.0.tgz

chown -R mongodb-mms:mongodb-mms /opt/mongodb/mms/mongodb-releases/*
chmod -R 640 /opt/mongodb/mms/mongodb-releases/*.tgz

