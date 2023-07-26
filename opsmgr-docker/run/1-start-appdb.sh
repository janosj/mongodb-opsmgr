#!/usr/bin/env bash
set -ueo pipefail

source ../env.conf

if [[ -z "$APPDB_VERSION" ]]; then
    echo "APPDB_VERSION not specified! Tried ../env.conf. Exiting."
    echo
    exit 1
fi

echo
echo "Starting a container for the AppDB. Using version $APPDB_VERSION..."
if ! docker start appdb; then
    echo "Did not find a previously running container, or could not restart it."
    echo "Launching a new one ..."
#    docker run --net=bridge --name appdb -p 27017:37017/tcp -d mongo:"$APPDB_VERSION"
    docker run --network $DOCKER_NETWORK --name appdb -p 27017:37017/tcp -d mongo:"$APPDB_VERSION"
fi

APPDB_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' appdb)

if [[ -z "$APPDB_IP" ]]; then
    echo
    echo "The AppDB doesn't seem to be running... Sorry. Exiting."
    echo
    exit 1
else
    echo "The AppDB is running at ${APPDB_IP}"
    echo 
    docker container ls
    echo
fi

