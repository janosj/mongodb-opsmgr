if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

yum install -y wget

# Community
wget -P /opt/mongodb/mms/mongodb-releases http://downloads.mongodb.org/linux/mongodb-linux-x86_64-rhel80-4.2.1.tgz

# Enterprise
# RHEL8
wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel80-5.0.2.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel80-4.4.9.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel80-4.4.3.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel80-4.2.5.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel80-4.2.3.tgz
# For testing major upgrades?
wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel80-4.0.17.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel80-4.0.16.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel80-3.6.17.tgz
# RHEL7
#wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel70-4.2.5.tgz
#wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel70-4.2.3.tgz
#wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel70-4.2.2.tgz
#wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel70-4.2.1.tgz

# for Kubernetes Operator (quay.io)
wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-ubuntu1604-4.2.5.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-ubuntu1604-4.2.1.tgz

# The docs say to also download Tools for local mode, and this ends up being required for Sharded clusters.
# Not easy to determine the vorrect version. See Parsons EA Demo Notes.
# Get the URL format from download center.
# Get the correct version from Ops Manager, when you CONFIRM before deploying (bottom of screen).  
# Or, see the error message if you try to deploy and it's not there.
wget -P /opt/mongodb/mms/mongodb-releases https://fastdl.mongodb.org/tools/db/mongodb-database-tools-rhel80-x86_64-100.5.0.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://fastdl.mongodb.org/tools/db/mongodb-database-tools-rhel80-x86_64-100.3.1.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://fastdl.mongodb.org/tools/db/mongodb-database-tools-rhel80-x86_64-100.2.0.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://fastdl.mongodb.org/tools/db/mongodb-database-tools-rhel80-x86_64-100.1.0.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://fastdl.mongodb.org/tools/db/mongodb-database-tools-rhel80-x86_64-100.0.2.tgz
#wget -P /opt/mongodb/mms/mongodb-releases https://fastdl.mongodb.org/tools/db/mongodb-database-tools-rhel70-x86_64-100.0.2.tgz
wget -P /opt/mongodb/mms/mongodb-releases https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu1604-x86_64-100.1.0.tgz

chown -R mongodb-mms:mongodb-mms /opt/mongodb/mms/mongodb-releases/*
chmod -R 640 /opt/mongodb/mms/mongodb-releases/*.tgz

