#MMSBASEURL=http://ip-x-x-x-x.ec2.internal:8080
MMSBASEURL=REPLACE_MMSBASEURL
MMSINTERNALIP=REPLACE_MMSINTERNALIP

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo "Adding opsmgr-aws to /etc/hosts..."
echo "$MMSINTERNALIP opsmgr-aws" >> /etc/hosts

echo "Setting timezone to US East Coast..."
timedatectl set-timezone America/New_York

# Added compat-openssl10 because I get an openssl error
# trying to run mongosqld (the BI Connector) on CentOS 8
echo Installing OS dependencies...
sudo yum install -y cyrus-sasl cyrus-sasl-gssapi cyrus-sasl-plain krb5-libs libcurl lm_sensors-libs net-snmp net-snmp-agent-libs openldap openssl xz-libs

# BI Connector would install but not run.
# Error message reported in /var/log/mongodb-mms-automation/mongosqld-<..>-fatal.log:
# "error while loading shared libraries: libssl.so.10: cannot open shared object file: No such file"
# Solution is here:
# https://stackoverflow.com/questions/57966184/libssl-so-10-cannot-open-shared-object-file-no-such-file-or-directory
# Fix (RHEL issue only; VirtualBox had a separate Ubuntu issue):
sudo yum install -y compat-openssl10

# Contains strings util for demonstrating encryption at rest...
sudo yum install -y binutils

# Ops Manager > Download Agent provides URL for specific agent version.
# URL for -latest- comes from docs: 
# https://docs.opsmanager.mongodb.com/current/tutorial/install-mongodb-agent-to-manage/#id100
# but note the link provided there (currently) is incorrect. JIRA submitted.
# -k option is to allow self-signed certificate
echo "Downloading agent ..."
curl -k -O $MMSBASEURL/download/agent/automation/mongodb-mms-automation-agent-manager-latest.x86_64.rhel7.rpm

echo Installing agent...
sudo rpm -U mongodb-mms-automation-agent-manager-latest.x86_64.rhel7.rpm

echo Copying config file...
cp ./automation-agent.config /etc/mongodb-mms/
chown mongod:mongod /etc/mongodb-mms/automation-agent.config

echo Copying CA File...
chown mongod:mongod opsmgrCA.pem
chmod 600 opsmgrCA.pem
cp -p ./opsmgrCA.pem /etc/mongodb-mms/

# This setup provides a lot of flexibility for MongoDB database storage. 
# You don't have to use it, you can just use /data if you don't overlap components. 
echo Making data directories...
mkdir -p /data
mkdir -p /data/shards
mkdir -p /data/configRS
mkdir -p /data/mongos
mkdir -p /data2
chown -R mongod:mongod /data
chown -R mongod:mongod /data2

echo Starting agent...
systemctl start mongodb-mms-automation-agent.service

echo Configuring agent to start automatically on reboot...
chkconfig mongodb-mms-automation-agent on

