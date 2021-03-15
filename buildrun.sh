#!/bin/bash

clear

REPOSITORY=$1

if [ -z "$REPOSITORY" ]
then
    REPOSITORY=dtdemos
fi

IMAGE=dt-orders-load
VERSION_TAG=1
FULLIMAGE=$REPOSITORY/$IMAGE:$VERSION_TAG

echo ""
echo "========================================================"
echo "Building $FULLIMAGE"
echo "========================================================"
./writeManifest.sh
docker build -t $FULLIMAGE .

echo ""
echo "========================================================"
echo "Ready to run $FULLIMAGE ?"
echo "========================================================"
read -rsp "Press ctrl-c to abort. Press any key to continue"
docker run \
    --env HOSTNAME=172.17.0.1 \
    --env SERVER_PORT=80 \
    --env NUM_LOOPS=1 \
    --env NUM_THREADS=1 \
    --env TEST_SCRIPT="/load.jmx" \
    --env TEST_DEBUG=false \
    --env THINK_TIME=250 \
    dtdemos/dt-orders-load:1