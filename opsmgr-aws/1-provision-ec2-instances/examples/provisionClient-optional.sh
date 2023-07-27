#!/bin/bash

# Provisions an EC2 instance to act as a Mongo client.
# This does not actuall install MongoDB, it only provisions the hardware.

source ./env.conf

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root to update the /etc/hosts file."
   exit 1
fi

AWS_TAG_NAME=<yourName>-client
AWS_TAG_OWNER=<your.name>
ROOT_VOL_GB=10
AWS_INSTANCE_TYPE=t3.small
AWS_IMAGE_ID=ami-098f16afa9edf40be    # RHEL 8.2
LOCAL_HOSTNAME_ENTRY=awsclient

node ../provisionEC2Instance.js $AWS_KEYFILE $AWS_SECURITY_GROUP $AWS_TAG_NAME $AWS_TAG_OWNER $ROOT_VOL_GB $AWS_INSTANCE_TYPE $AWS_IMAGE_ID $LOCAL_HOSTNAME_ENTRY

