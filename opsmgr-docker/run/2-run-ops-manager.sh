#!/usr/bin/env bash
set -ueo pipefail

source ../env.conf

APPDB_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' appdb)
if [[ -z "$APPDB_IP" ]]; then
    echo "AppDB doesn't appear to be running. Exiting."
    echo
    exit 1
fi

echo "Found AppDB container running at $APPDB_IP."

if [[ -z "$OM_TAG" ]]; then
    echo "OM_TAG not specified! Tried ../env.conf. Exiting."
    echo
    exit 1
fi
if [[ -z "$OM_RUN_VERSION" ]]; then
    echo "OM_RUN_VERSION not specified! Tried ../env.conf. Exiting."
    echo
    exit 1
fi

OM_VERSION=$OM_RUN_VERSION

echo "Starting Ops Manager $OM_VERSION"
docker rm -f "ops-manager-$OM_VERSION"
docker run \
    --name "ops-manager" \
    --hostname "ops-manager.$DOCKER_NETWORK" \
    --env VERSION="$OM_VERSION" \
    --env APPDB_IP="$APPDB_IP" \
    --env APPDB_PORT="27017" \
    --env OM_PORT="8080" \
    --network $DOCKER_NETWORK \
    -p "8080:8080/tcp" \
    -it "$OM_TAG:$OM_VERSION"

