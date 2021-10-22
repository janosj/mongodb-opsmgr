FROM ubuntu:18.04

# Install the agent, the mongod dependencies, plus: curl, numactl & psmisc
# For mongod dependencies see: https://docs.mongodb.com/manual/tutorial/install-mongodb-enterprise-on-linux/
RUN set -x \
    && apt-get update -y \
    && apt-get install -y \
    libcurl4 libgssapi-krb5-2 \
    libkrb5-dbg libldap-2.4-2 libpci3 libsasl2-2 snmp \
     liblzma5 openssl \
        curl \
        libpcap0.8 \
        libpci3 \
        libsensors4 \
        libsnmp30 \
        libssl1.0.0 \
        libssl-dev \
        libwrap0 \
        liblzma5 \
        openssl \
        numactl \
        psmisc \
        rsyslog \
        binutils \
    && sed -i 's/module(load="imklog"/# module(load="imklog"/' /etc/rsyslog.conf \
    # modified for SSL
    # -k option is a hack to allow self-signed certificate
    && curl -kOL https://172.17.0.1:8443/download/agent/automation/mongodb-mms-automation-agent-manager_latest_amd64.ubuntu1604.deb \
    && dpkg -i mongodb-mms-automation-agent-manager_latest_amd64.ubuntu1604.deb \
    && rm -rf mongodb-mms-automation-agent-manager_latest_amd64.ubuntu1604.deb \
    && apt-get autoremove \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && service rsyslog start

# Required to allow self-signed certificate.
COPY opsmgrCA.pem /etc/mongodb-mms

# Two main volumes to be mounted to external volumes: 
#  1) Place for all mongodb cluster configuration & data files
#  2) Place for agent & db binary downloads, for quicker mongod re-start whenever containers are recycled
VOLUME /data /data2 /var/lib/mongodb-mms-automation
RUN chown mongodb:mongodb /data /data2 /var/lib/mongodb-mms-automation

# Range of potential ports for Ops Manager configured mongod's to listen on
EXPOSE 27000-28000

# Wrapper script to start the main command (CMD) in the background and register a SIGTERM handler
COPY start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh
ENTRYPOINT ["start.sh"]

# Default to just showing agent help output (see below for proper container start-up command example)
CMD ["/opt/mongodb-mms-automation/bin/mongodb-mms-automation-agent", "-h"]


###############
# HELP / TIPS #
###############

# To build:
# $ docker build -t mongodb/automation-agent .

# To run (replace YYYY & ZZZZ with your docker hub tag prefix from above, your Ops Manager Group ID (Project ID) and your Ops Manager API Key, respectively):
# $ docker run --add-host opsmgr:172.17.0.1 -d --name automation-agent-container -t mongodb/automation-agent /opt/mongodb-mms-automation/bin/mongodb-mms-automation-agent --mmsGroupId=YYYY --mmsApiKey=ZZZZ --mmsBaseUrl=http://172.17.0.1:8080 -logLevel=INFO

