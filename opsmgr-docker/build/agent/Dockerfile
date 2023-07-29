FROM amazonlinux:2
# Note: I encountered some issues using Amazon Linux 2013,
# I couldn't deploy a database: "libcrypto.so.10 cannot open shared object file: no such file or directory".

# Linux dependencies when installing MongoDB Enterprise.
# This is conveyed in a modal when you try to deploy.
# Points to documentation here:
# https://www.mongodb.com/docs/ops-manager/current/tutorial/provisioning-prep/index.html#installing-mongodb-enterprise-dependencies
# Switch to Amazon Linux tab (Amazon Linux 2).
RUN yum install -y cyrus-sasl cyrus-sasl-gssapi \
     cyrus-sasl-plain krb5-libs libcurl \
     lm_sensors-libs net-snmp net-snmp-agent-libs \
     openldap openssl tcp_wrappers-libs xz-libs

# Additional packages:
#   shadow-utils: ?
#   procps:       for the ps command
#   hostname:     agent fails to start without it.
RUN yum update \
 && yum install -y shadow-utils \
                   procps \
                   hostname \
 && yum clean all \
 && rm -rf /var/cache/yum

COPY downloaded-agent.aarch64.amzn2.rpm .
RUN rpm -U ./downloaded-agent.aarch64.amzn2.rpm \
    && rm ./downloaded-agent.aarch64.amzn2.rpm

# External volume for db binary downloads.
# Not setting this, so it's a clean start every time.
# VOLUME /var/lib/mongodb-mms-automation

# Directories for the MDB data and log files have to be created in advance.
# At a minimum you need /data.
# This setup provides a lot of flexibility if you need to stack multiple components on a single node.
RUN mkdir -p /data \
 && mkdir -p /data/db1 \
 && mkdir -p /data/db2 \
 && mkdir -p /data/performanceDB \
 && mkdir -p /data/shards \
 && mkdir -p /data/configRS \
 && mkdir -p /data/mongos \
 && mkdir -p /data/bic \
 && mkdir -p /data2 \
 && chown -R mongod:mongod /data \
 && chown -R mongod:mongod /data2

# Range of potential ports for any deployed mongod's to listen on
# Enables remote database connectivity.
EXPOSE 27000-28000

# Wrapper script to start the main command (CMD) in the background and register a SIGTERM handler
COPY /scripts/start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh
ENTRYPOINT ["start.sh"]

# Default to just showing agent help output (see below for proper container start-up command example)
CMD ["/opt/mongodb-mms-automation/bin/mongodb-mms-automation-agent", "-h"]

#
# To run (for i in 1..agent-count):
# docker run -d --network $DOCKER_NETWORK --name server${i} --hostname server${i}.$DOCKER_NETWORK -t "$AGENT_TAG" /opt/mongodb-mms-automation/bin/mongodb-mms-automation-agent --mmsGroupId=$MMSGROUPID --mmsApiKey=$MMSAPIKEY --mmsBaseUrl=http://$OM_URL:$OM_PORT -logLevel=INFO
#


