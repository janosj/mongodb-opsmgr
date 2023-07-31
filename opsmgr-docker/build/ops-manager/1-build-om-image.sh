#!/usr/bin/env bash
set -eo pipefail

# Expecting values for OM_TAG, OM_BUILD_VERSION, and JDK_ARM64_BINARY.
source ../../env.conf

if [[ -z "$OM_TAG" ]]; then
    echo "OM_TAG not specified (tried ../../env.conf). Exiting."
    echo
    exit 1
fi
if [[ -z "$OM_BUILD_VERSION" ]]; then
    echo "OM_BUILD_VERSION not specified (tried ../../env.conf). Exiting."
    echo
    exit 1
fi
if [[ -z "$OM_DOWNLOAD_URL" ]]; then
    echo "OM_DOWNLOAD_URL not specified (tried ../../env.conf). Exiting."
    echo
    exit 1
fi
if [[ -z "$JDK_ARM64_BINARY" ]]; then
    echo "JDK_ARM64_BINARY not specified (tried ../../env.conf). Exiting."
    echo
    exit 1
fi

OM_VERSION=$OM_BUILD_VERSION

# Download the OM binary locally, if it doesn't already exist.
OM_FILENAME=ops_manager.$OM_VERSION.tar.gz
if [ ! -f $OM_FILENAME ]
then
    echo "Downloading OM $OM_VERSION..."
    curl -L -o $OM_FILENAME $OM_DOWNLOAD_URL
else
    echo "Ops Manager $OM_VERSION binary already downloaded."
fi

echo "Building the container for the local target architecture..."
# Ops Manager doesn't officially support ARM. See here:
# https://www.mongodb.com/docs/ops-manager/current/core/requirements/#operating-systems-compatible-with-onprem
# The normal x86_64 binary is used. 

echo
docker build \
    --no-cache \
    --build-arg OM_VERSION="$OM_VERSION" \
    --build-arg TARGETARCH="arm64" \
    --build-arg JDK_ARM64_BINARY="$JDK_ARM64_BINARY" \
    --tag "$OM_TAG:$OM_VERSION" \
    --tag "$OM_TAG:latest" \
    .

