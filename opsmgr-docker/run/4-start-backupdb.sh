#!/usr/bin/env bash
set -ueo pipefail

source ../env.conf
HOST_PORT=37018

if [[ -z "$APPDB_VERSION" ]]; then
    echo "APPDB_VERSION not specified! (will use the same for the Backup DB). Tried ../env.conf. Exiting."
    echo
    exit 1
fi
BACKUPDB_VERSION=$APPDB_VERSION

echo
echo "Starting a container for the BackupDB. Using version $BACKUPDB_VERSION..."
if ! docker start backupdb; then
    echo "Did not find a previously running container, or could not restart it."
    echo "Launching a new one ..."
    docker run --network $DOCKER_NETWORK --name backupdb -p $HOST_PORT:27017 -d mongo:"$BACKUPDB_VERSION"
fi

BACKUPDB_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' backupdb)

if [[ -z "$BACKUPDB_IP" ]]; then
    echo
    echo "It doesn't appear that the BackupDB launched successfully... Sorry. Exiting."
    echo
    exit 1
else
    echo "The BackupDB is now running at ${BACKUPDB_IP}"
    echo "It's reachable from your host at localhost:$HOST_PORT."
    echo 
    docker container ls
    echo
fi

