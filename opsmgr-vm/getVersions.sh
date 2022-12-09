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

download_file mongodb-linux-x86_64-enterprise-ubuntu1804-6.0.3.tgz https://downloads.mongodb.com/linux
download_file mongodb-linux-x86_64-enterprise-ubuntu1804-6.0.1.tgz https://downloads.mongodb.com/linux
download_file mongodb-linux-x86_64-enterprise-ubuntu1804-5.0.14.tgz https://downloads.mongodb.com/linux
download_file mongodb-linux-x86_64-enterprise-ubuntu1804-5.0.3.tgz https://downloads.mongodb.com/linux
download_file mongodb-linux-x86_64-enterprise-ubuntu1804-4.4.3.tgz https://downloads.mongodb.com/linux
download_file mongodb-linux-x86_64-enterprise-ubuntu1804-4.4.1.tgz https://downloads.mongodb.com/linux
download_file mongodb-linux-x86_64-enterprise-ubuntu1804-4.2.5.tgz https://downloads.mongodb.com/linux
download_file mongodb-linux-x86_64-enterprise-ubuntu1804-4.2.1.tgz https://downloads.mongodb.com/linux

download_file mongodb-database-tools-ubuntu1804-x86_64-100.6.0.tgz https://fastdl.mongodb.org/tools/db

echo "Updating owner and permissions..."
chown -R mongodb-mms:mongodb-mms $DOWNLOAD_FOLDER/*
chmod -R 640 $DOWNLOAD_FOLDER/*.tgz
echo "Done."

