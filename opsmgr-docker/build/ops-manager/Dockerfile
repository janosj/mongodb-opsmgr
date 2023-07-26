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
# Required at runtime:
#   procps (ps)
#   net-tools (netstat)
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

# COPY and extract OM file
# Expects OM binary to have been downloaded previously by the build script.
COPY ops_manager.$OM_VERSION.tar.gz ./ops_manager.tar.gz
RUN mkdir -p /root/mongodb-mms \
    && chmod -R 0777 /root/mongodb-mms \
    && tar -xzf ops_manager.tar.gz -C /root/mongodb-mms --strip-components 1 \
    && rm -rf ops_manager.tar.gz

# Replaces the JDK with the ARM64 version (the JDK version should match the OM release). 
# Download an ARM64 OpenJDK (this only happens if the Targeted Architecture is arm64)
RUN echo "Replacing JDK with ARM version from $JDK_ARM64_BINARY..." \
    && curl -sLo jdk11-arm64.tar.gz "$JDK_ARM64_BINARY" \
    && tar -xzf jdk11-arm64.tar.gz \
    && rm -rf jdk11-arm64.tar.gz \
    && rm -rf mongodb-mms/jdk \
    && mv jdk-* jdk \
    && mv jdk mongodb-mms/

# Configure Ops Manager (edit the script for any config changes, then run `make clean build`)
RUN /root/scripts/configure-om.sh

# Startup command
CMD echo && echo "WARNING: DO NOT USE IN A PRODUCTION ENVIRONMENT!" && echo \
    && scripts/replace_property_in_file.sh "/root/mongodb-mms/conf/conf-mms.properties" "mongo.mongoUri" "mongodb://${APPDB_IP}:${APPDB_PORT}" \
    && scripts/replace_property_in_file.sh "/root/mongodb-mms/conf/conf-mms.properties" "mms.centralUrl" "http://$(ifconfig eth0 | grep -oP 'inet \K\S+'):${DEFAULT_OM_PORT}" \
    && /root/mongodb-mms/bin/start-mongodb-mms --enc-key-path /etc/mongodb-mms/gen.key \
    && tail -n 1000 -F /root/mongodb-mms/etc/mongodb-mms/data/logs/mms0-startup.log /root/mongodb-mms/etc/mongodb-mms/data/logs/mms0.log
