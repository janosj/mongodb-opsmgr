#!/bin/bash

# Provisions a single box to host an MDB standalone.

source ./env.conf

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root to update the /etc/hosts file."
   exit 1
fi

ROOT_VOL_GB=10
AWS_INSTANCE_TYPE=t3.medium
AWS_IMAGE_ID=ami-06640050dc3f556bb   # RHEL 8
#IMAGE_ID=ami-00ddb0e5626798373      # Ubuntu 18.04
AWS_TAG_NAME=<yourName>-standalone
LOCAL_HOSTNAME_ENTRY=mdb1

echo Provisioning single instance...

node ../provisionEC2Instance.js $AWS_KEYFILE $AWS_SECURITY_GROUP $AWS_TAG_NAME $AWS_TAG_OWNER $ROOT_VOL_GB $AWS_INSTANCE_TYPE $AWS_IMAGE_ID $LOCAL_HOSTNAME_ENTRY

echo 
echo Done.
echo
