#!/usr/bin/env bash
set -ueo pipefail

source ../env.conf
HOST_PORT=37017

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
    docker run --network $DOCKER_NETWORK --name appdb -p $HOST_PORT:27017 -d mongo:"$APPDB_VERSION"
fi

APPDB_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' appdb)

if [[ -z "$APPDB_IP" ]]; then
    echo
    echo "It doesn't appear that AppDB launched successfully... Sorry. Exiting."
    echo
    exit 1
else
    echo
    echo "The AppDB is now running at ${APPDB_IP}"
    echo "It's reachable from your host at localhost:$HOST_PORT."
    echo 
    docker container ls
    echo
fi

