# Simple Test Ops Manager Installation
# Docs: https://docs.opsmanager.mongodb.com/current/tutorial/install-simple-test-deployment/
# WARNING: Not suitable for a production deployment.

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

OMFILE=mongodb-mms-5.0.3.100.20211005T2044Z-1.x86_64.rpm
OMFILEPATH=./$OMFILE
OMURL=https://downloads.mongodb.com/on-prem-mms/rpm/$OMFILE

echo "Setting hostname to 'opsmgr-aws'..."
# Prereq: use opsmgr-aws as internal and external hostname.
# This will be specified in the server's self-signed SSL certificate.
hostnamectl set-hostname opsmgr-aws

echo "Setting timezone to US East Coast..."
timedatectl set-timezone America/New_York

# Install OS dependencies
# Here: https://docs.opsmanager.mongodb.com/v5.0/tutorial/provisioning-prep/index.html#installing-mongodb-enterprise-dependencies
sudo yum install -y cyrus-sasl cyrus-sasl-gssapi cyrus-sasl-plain krb5-libs libcurl net-snmp net-snmp-libs openldap openssl xz-libs


# 1: Ensure ulimit settings meet minimum requirements.
# Ops Manager fails if these aren't in place, especially once you enable backups.
echo Increasing system limits for mongod user...
cp limits.conf /etc/security

# 2: Configure yum to install MongoDB
echo
echo Configuring Yum repo....
echo "[mongodb-org-5.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/8/mongodb-org/5.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-5.0.asc" | sudo tee /etc/yum.repos.d/mongodb-org-5.0.repo

# 3: Install MongoDB
echo
echo Installing MongoDB...
yum install -y mongodb-org

# 4: Disable the mongod service
systemctl disable mongod

# 5: Create the OM AppDB directory
echo
echo Creating AppDB directories...
mkdir -p /data/appdb
chown -R mongod:mongod /data

# 6: Update the MongoDB configuration file.
# No Changes

# 7: Start the OM AppDB Database mongod instance
echo
echo Starting AppDB database...
sudo -u mongod mongod --port 27017 --dbpath /data/appdb --logpath /data/appdb/mongodb.log --wiredTigerCacheSizeGB 1 --fork

# 8: Download the Ops Manager package.
if [ ! -f "$OMFILEPATH" ]; then
  echo "Ops Manager RPM not found locally."
  echo "Downloading Ops Manager RPM from MongoDB.com..."
  curl $OMURL --output $OMFILEPATH
fi

# 9: Unnecessary.

# 10: Install Ops Manager
echo
echo Installing Ops Manager...
yum install -y $OMFILEPATH

# JJ: Copy config file with local mode settings. 
echo
echo Copying config file with local mode settings...
cp /opt/mongodb/mms/conf/conf-mms.properties /opt/mongodb/mms/conf/conf-mms.properties.original
sed "s/INTERNAL_HOSTNAME/$HOSTNAME/g" conf-mms.properties > /opt/mongodb/mms/conf/conf-mms.properties

# JJ: Added SSL configuration.
echo 
echo "Configuring SSL..."
# Create self-signed cert
# Note: subjectAltName (SAN) is required by Chrome browsers
# If this generates an error (can't load /home/opsmgr/.rnd into RNG),
# the fix is to comment RANDFILE line in /etc/ssl/openssl.cnf
openssl req -newkey rsa:2048 -nodes -keyout opsmgrCA.key -x509 -subj "/CN=opsmgr-aws" -addext "subjectAltName = DNS:opsmgr-aws" -days 365 -extensions v3_ca -out opsmgrCA.crt
cat opsmgrCA.crt opsmgrCA.key > opsmgrCA.pem
sudo chown mongodb-mms:mongodb-mms opsmgrCA.pem
sudo chmod 600 opsmgrCA.pem
sudo cp -p opsmgrCA.pem /etc/mongodb-mms
# self-signed cert will have to be copied to laptop and agents
sudo cp opsmgrCA.pem ~ec2-user
sudo chmod 777 ~ec2-user/opsmgrCA.pem

# JJ: Added for local mode.
echo
echo "Downloading MongoDB versions for local mode operation..."
./getVersions.sh

# STEP 11: Start Ops Manager
echo
echo Starting Ops Manager...
service mongodb-mms start

# JJ: configure backups via blockstore
# (Considerations section of docs say instructions don't include backup).
# For Blockstore, if selected, and also the S3 metadata, if selected.
# Not used with a file system store?
echo
echo Setting up Backup database...
mkdir -p /data/backup
chown mongod:mongod /data/backup

sudo -u mongod mongod --port 27018 --dbpath /data/backup --logpath /data/backup/mongodb.log --wiredTigerCacheSizeGB 1 --fork

mkdir /data/headdb
sudo chown mongodb-mms:mongodb-mms /data/headdb

#mkdir /data/filestore
#sudo chown mongodb-mms:mongodb-mms /data/filestore

# Trick to get the public DNS of this server
# (no longer needed since switching to SSL which uses opsmgr-aws)
# PUBLIC_HOSTNAME="$(curl http://169.254.169.254/latest/meta-data/public-hostname 2>/dev/null)"

echo 
echo "Ops Manager installation complete."
echo "Run the next script from your laptop to get the CA cert,"
echo "then access the Ops Manager UI (https://opsmgr-aws:8443 assuming it's in your /etc/hosts)"
echo "and create the initial user (i.e. register for new account)."
echo "Required settings are already configured."
echo "Navigate to Deployment > Agents > Downloads & Settings."
echo "Select your operating system."
echo "Use the information from this page when you run transfer-agent-config-files.sh"
echo "That script also pulls down the server cert (for local use) and pushes it to the agents."
echo "Then ssh to each agent box to install the agents."
echo "You're ready to demo! Good luck!"

