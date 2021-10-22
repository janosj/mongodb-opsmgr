if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Added compat-openssl10 because I get an openssl error
# trying to run mongosqld (the BI Connector) on CentOS 8
echo Installing OS dependencies...
sudo apt-get update
sudo apt-get install libcurl4 libgssapi-krb5-2 \
     libkrb5-dbg libldap-2.4-2 libpci3 libsasl2-2 snmp \
     liblzma5 openssl

# Discovered this while troubleshooting BI Connector.
# Would not install. Latest version had log file, revealed libssl.so.10 not found.
# Solution online here: https://stackoverflow.com/questions/57966184/libssl-so-10-cannot-open-shared-object-file-no-such-file-or-directory
#sudo yum install -y compat-openssl10

echo Installing binutils, which contains strings for encryption at rest...
sudo yum install -y binutils

# Copy this URL from Ops Manager Donwload Agent settings.
echo Downloading agent...
curl -OL http://ip-172-31-55-18.ec2.internal:8080/download/agent/automation/mongodb-mms-automation-agent-manager_10.14.17.6445-1_amd64.ubuntu1604.deb

# Copy this from Ops Manager Download Agent settings.
echo Installing agent...
sudo dpkg -i mongodb-mms-automation-agent-manager_10.14.17.6445-1_amd64.ubuntu1604.deb

#echo Installing MMS Agent Package...
#yum install -y $AGENTFILE

echo Copying config file...
cp ./automation-agent.config /etc/mongodb-mms/automation-agent.config
chown mongodb:mongodb /etc/mongodb-mms/automation-agent.config

# This setup provides a lot of flexibility. You don't have to use it, you can just use /data if you don't overlap components. 
echo Making data directories...
mkdir -p /data
mkdir -p /data/shards
mkdir -p /data/configRS
mkdir -p /data/mongos
mkdir -p /data2

chown -R mongodb:mongodb /data
chown -R mongodb:mongodb /data2

echo Starting agent...
systemctl start mongodb-mms-automation-agent.service

echo Configuring agent to start automatically on reboot...
# not tested for Ubuntu
chkconfig mongodb-mms-automation-agent on

