# Install MDB standalone
# Use to import existing MDB deployment into Ops Manager.
# https://docs.mongodb.com/v4.4/tutorial/install-mongodb-enterprise-on-red-hat/

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo "Setting timezone to US East Coast..."
timedatectl set-timezone America/New_York

# ulimit settings
# https://docs.mongodb.com/v4.4/reference/ulimit/
echo Increasing system limits for mongod user...
cp limits.conf /etc/security

# configure yum repo
echo
echo Configuring Yum repo....
echo "[mongodb-enterprise-4.4]
name=MongoDB Enterprise Repository
baseurl=https://repo.mongodb.com/yum/redhat/8/mongodb-enterprise/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc" | sudo tee /etc/yum.repos.d/mongodb-enterprise-4.4.repo

# Install MongoDB
echo
echo Installing MongoDB...
yum install -y mongodb-enterprise
cp mongod.conf /etc

# auto-start
systemctl enable mongod

echo "Installation complete."
echo "Disabling SE Linux and rebooting..."
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
reboot


