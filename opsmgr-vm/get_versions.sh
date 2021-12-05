#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

DOWNLOAD_URL=https://downloads.mongodb.com/linux
DOWNLOAD_FOLDER=/opt/mongodb/mms/mongodb-releases

download_file () {

   local file_to_download=$1

   if [ ! -f $DOWNLOAD_FOLDER/$file_to_download ]
   then
     echo "Downloading $file_to_download..."
     curl -o $DOWNLOAD_FOLDER/$file_to_download $DOWNLOAD_URL/$file_to_download
   else
     echo "$file_to_download already downloaded."
   fi

}

download_file mongodb-linux-x86_64-enterprise-ubuntu1804-5.1.0.tgz
download_file mongodb-linux-x86_64-enterprise-ubuntu1804-5.0.3.tgz
download_file mongodb-linux-x86_64-enterprise-ubuntu1804-4.4.3.tgz
download_file mongodb-linux-x86_64-enterprise-ubuntu1804-4.4.1.tgz
download_file mongodb-linux-x86_64-enterprise-ubuntu1804-4.2.5.tgz
download_file mongodb-linux-x86_64-enterprise-ubuntu1804-4.2.1.tgz
download_file mongodb-linux-x86_64-enterprise-ubuntu1804-4.0.20.tgz
download_file mongodb-linux-x86_64-enterprise-ubuntu1804-3.6.20.tgz
# Different download URL
curl -o $DOWNLOAD_FOLDER/mongodb-database-tools-ubuntu1804-x86_64-100.5.0.tgz https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu1804-x86_64-100.5.0.tgz
download_file mongodb-database-tools-ubuntu1804-x86_64-100.5.0.tgz
download_file mongodb-database-tools-ubuntu1804-x86_64-100.3.1.tgz
download_file mongodb-database-tools-ubuntu1804-x86_64-100.2.0.tgz
download_file mongodb-database-tools-ubuntu1804-x86_64-100.1.0.tgz

echo "Updating owner and permissions..."
chown -R mongodb-mms:mongodb-mms $DOWNLOAD_FOLDER/*
chmod -R 640 $DOWNLOAD_FOLDER/*.tgz
echo "Done."

