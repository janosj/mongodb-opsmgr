#!/bin/bash

# Provisions the specified number of EC2 instances for the MongoDB Agents.
# This does not actually install any agents, it only provisions the hardware.

source ./env.conf

ROOT_VOL_GB=10
AWS_INSTANCE_TYPE=t3.medium
AWS_IMAGE_ID=ami-098f16afa9edf40be   # RHEL 8.2
#AWS_IMAGE_ID=ami-00ddb0e5626798373  # Ubuntu 18.04


# Provisions the specified number of EC2 instances
# for MongoDB Agents..

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root to update the /etc/hosts file."
   exit 1
fi

if [ -z "$1" ]; then
    echo "No argument supplied"
    echo "Usage: provisionAgents.sh <agent-node-count>"
    exit 1
fi

if [ "$1" -gt 9 ]; then
    echo "This script cannot deploy more than 9 agent nodes currently."
    echo "To fix, modify the updateHosts script - currently the string matching will confuse agent1 with agent10."
    echo "Exiting."
    exit 1
fi

i="0"
while [ $i -lt $1 ]; do

  i=$[$i+1]

  echo 
  echo Provisioning agent$i...
  awsTag_Name=<yourName>-agent$i
  localEtcHostname=agent$i

  node ../provisionEC2Instance.js $AWS_KEYFILE $AWS_SECURITY_GROUP $awsTag_Name $AWS_TAG_OWNER $ROOT_VOL_GB $AWS_INSTANCE_TYPE $AWS_IMAGE_ID $localEtcHostname

done

echo 
echo Done.
echo
