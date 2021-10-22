#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-ubuntu1804-4.4.3.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-ubuntu1804-4.4.1.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-ubuntu1804-4.2.5.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-ubuntu1804-4.2.1.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-ubuntu1804-4.0.20.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-ubuntu1804-3.6.20.tgz

wget -P /opt/mongodb/mms/mongodb-releases https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu1804-x86_64-100.3.1.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu1804-x86_64-100.2.0.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu1804-x86_64-100.1.0.tgz

chown -R mongodb-mms:mongodb-mms /opt/mongodb/mms/mongodb-releases/*
chmod -R 640 /opt/mongodb/mms/mongodb-releases/*.tgz
