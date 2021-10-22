#!/bin/bash

# Transfers fully configured  agent config files to the specified number of agent instances.
# Required information includes:
#   mmsGroupId: goes in the automation-agent.config file
#   mmsApiKey : goes in the automation-agent.config file
#   mmsBaseUrl: goes in both the aa.config file and the install.sh file
#
# You can do this on each agent node before installing the agent, which gets cumbersome.
# Or, using this script, just do it once on your laptop, and transfer the fully-configured 
# files to all agents.

if [ -z "$1" ]; then
    echo "No argument supplied"
    echo "Usage: transferAgentConfigFiles.sh <agent-node-count>"
    exit 1
fi

# Check for Ops Mgr server cert (required by agent for SSL access)
if [ ! -f ~/Downloads/opsmgrCA.pem ]; then
  echo "Could not find opsmgrCA.pem file in ~/Downloads."
  echo "(Did you run ../1-install-opsMgr/2-get-server-cert.sh?)"
  echo "Exiting - agents can't connect without that cert."
  exit 1
fi

read -p "Name of AWS keyfile to connect to EC2 instances (no extension): " KEYFILE

read -p "Ops Manager Internal IP (for agents to connect): " MMSINTERNALIP

echo "Get this next two from Ops Manager > Agents > Downloads & Settings..."
read -p "mmsGroupId: " MMSGROUPID
read -p "mmsApiKey: " MMSAPIKEY

#read -p "mmsBaseUrl (including protocol and port): " MMSBASEURL
MMSBASEURL=https://opsmgr-aws:8443


# Replace "/" with "\/" so that sed handles it properly.
MMSBASEURL_ESCAPE="${MMSBASEURL////\/}"

# Modify the files with the supplied information
cp automation-agent.config automation-agent.config.tmp
sed -i .sed.tmp "s/REPLACE_MMSGROUPID/$MMSGROUPID/g" automation-agent.config.tmp
sed -i .sed.tmp "s/REPLACE_MMSAPIKEY/$MMSAPIKEY/g" automation-agent.config.tmp
sed -i .sed.tmp "s/REPLACE_MMSBASEURL/$MMSBASEURL_ESCAPE/g" automation-agent.config.tmp
cp install-agent.sh install-agent.sh.tmp
chmod +x install-agent.sh.tmp
sed -i .sed.tmp "s/REPLACE_MMSBASEURL/$MMSBASEURL_ESCAPE/g" install-agent.sh.tmp
sed -i .sed.tmp "s/REPLACE_MMSINTERNALIP/$MMSINTERNALIP/g" install-agent.sh.tmp

# Transfer the completed files to all agents.
i="0"
while [ $i -lt $1 ]; do

  i=$[$i+1]
  echo 
  echo Transfering files to agent$i...

  scp -i $HOME/Keys/$KEYFILE.pem ./automation-agent.config.tmp ec2-user@agent$i:./automation-agent.config
  scp -i $HOME/Keys/$KEYFILE.pem ./install-agent.sh.tmp ec2-user@agent$i:./install-agent.sh
  scp -i $HOME/Keys/$KEYFILE.pem ~/Downloads/opsmgrCA.pem ec2-user@agent$i:.

done

echo "Deleting tmp files..."
rm *.tmp

echo 
echo Done.
echo

