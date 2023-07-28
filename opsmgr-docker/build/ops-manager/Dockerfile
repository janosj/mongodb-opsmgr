FROM amazonlinux:2
#FROM ubuntu:20.04

ARG OM_VERSION
ARG JDK_ARM64_BINARY
ARG APPDB_PORT

ENV DEFAULT_OM_PORT=8080

USER root
WORKDIR /root
EXPOSE $DEFAULT_OM_PORT/tcp

# OS dependencies required by commands used in this Dockerfile
# + additional packages Required at runtime:
#    procps (ps)
#    net-tools (netstat)
RUN yum install -y tar gzip openssl \
                   procps net-tools

# TO-DO: Check this - are they in place? Requires reboot?
# Ensure ulimit settings meet minimum requirements.
# Ops Manager fails if these aren't in place, especially once you enable backups.
COPY limits.conf /etc/security

# Specify Ops Manager version
RUN test -n "$OM_VERSION" || (echo "OM_VERSION must be set (e.g., '5.0.10')" && false)

# Copy the setup scripts
COPY scripts /root/scripts

# COPY, extract, and configure OM
# Expects OM binary to have been downloaded previously by the build script.
COPY ops_manager.$OM_VERSION.tar.gz ./ops_manager.tar.gz
RUN echo "Copying, extracting, and configuring OM ..." \
 && mkdir -p /root/mongodb-mms \
 && chmod -R 0777 /root/mongodb-mms \
 && tar -xzf ops_manager.tar.gz -C /root/mongodb-mms --strip-components 1 \
 && rm -rf ops_manager.tar.gz \
 && /root/scripts/configure-om.sh

# Replaces the JDK with the ARM64 version (the JDK version should match the OM release). 
# Download an ARM64 OpenJDK (this only happens if the Targeted Architecture is arm64)
RUN echo "Replacing JDK with ARM version from $JDK_ARM64_BINARY..." \
 && curl -sLo jdk11-arm64.tar.gz "$JDK_ARM64_BINARY" \
 && tar -xzf jdk11-arm64.tar.gz \
 && rm -rf jdk11-arm64.tar.gz \
 && rm -rf mongodb-mms/jdk \
 && mv jdk-* jdk \
 && mv jdk mongodb-mms/

# Startup:
# Locks down the config settings for the Ops Manager UI and hte APPDB.
# Starts Ops Manager (the gen.key file is create by the configure-om.sh script).
# Starts the backup daemon.
# Tails the log files. 
CMD echo && echo "WARNING: DO NOT USE IN A PRODUCTION ENVIRONMENT!" && echo \
    && scripts/replace_property_in_file.sh "/root/mongodb-mms/conf/conf-mms.properties" "mongo.mongoUri" "mongodb://${APPDB_IP}:${APPDB_PORT}" \
    && scripts/replace_property_in_file.sh "/root/mongodb-mms/conf/conf-mms.properties" "mms.centralUrl" "http://$(ifconfig eth0 | grep -oP 'inet \K\S+'):${DEFAULT_OM_PORT}" \
    && /root/mongodb-mms/bin/start-mongodb-mms --enc-key-path /root/.mongodb-mms/gen.key \
    && /root/mongodb-mms/bin/mongodb-mms-backup-daemon start \
    && tail -n 1000 -F /root/mongodb-mms/etc/mongodb-mms/data/logs/mms0-startup.log /root/mongodb-mms/etc/mongodb-mms/data/logs/mms0.log
