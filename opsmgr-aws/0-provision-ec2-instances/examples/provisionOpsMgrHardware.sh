#!/bin/bash

# Provisions an EC2 instance to host MongoDB Ops Manager.
# This does not actually install Ops Manager, it only provisions the hardware.

source ./env.conf

AWS_TAG_NAME=<yourName>-opsmgr
ROOT_VOL_GB=30
AWS_INSTANCE_TYPE=m4.xlarge
AWS_IMAGE_ID=ami-098f16afa9edf40be    # RHEL 8.2
LOCAL_HOSTNAME_ENTRY=opsmgr-aws

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root to update the /etc/hosts file."
   exit 1
fi

node ../provisionEC2Instance.js $AWS_KEYFILE $AWS_SECURITY_GROUP $AWS_TAG_NAME $AWS_TAG_OWNER $ROOT_VOL_GB $AWS_INSTANCE_TYPE $AWS_IMAGE_ID $LOCAL_HOSTNAME_ENTRY

