#!/bin/bash

HOSTNAME=$1
if [ -z "$HOSTNAME" ]
then
    HOSTNAME=172.17.0.1
fi

SERVER_PORT=$2
if [ -z "$SERVER_PORT" ]
then
    SERVER_PORT=80
fi

NUM_LOOPS=$3
if [ -z "$NUM_LOOPS" ]
then
    NUM_LOOPS=100000
fi

NUM_THREADS=$4
if [ -z "$NUM_THREADS" ]
then
    NUM_THREADS=1
fi

THINK_TIME=$5
if [ -z "$THINK_TIME" ]
then
    THINK_TIME=250
fi

TEST_SCRIPT=$6
if [ -z "$TEST_SCRIPT" ]
then
    TEST_SCRIPT="load.jmx"
fi

TEST_DEBUG=$7
if [ -z "$TEST_DEBUG" ]
then
    TEST_DEBUG=false
fi

REPOSITORY=dtdemos
IMAGE=dt-orders-load
VERSION_TAG=1
FULLIMAGE=$REPOSITORY/$IMAGE:$VERSION_TAG

if [ "$TEST_DEBUG" == "true" ]
then
    echo "Running docker foreground mode"
    docker run -it \
        --env HOSTNAME=$HOSTNAME \
        --env SERVER_PORT=$SERVER_PORT \
        --env NUM_LOOPS=$NUM_LOOPS \
        --env NUM_THREADS=$NUM_THREADS \
        --env THINK_TIME=$THINK_TIME \
        --env TEST_SCRIPT=$TEST_SCRIPT \
        --env TEST_DEBUG=$TEST_DEBUG \
        --label dt-orders-load \
        $FULLIMAGE
else
    echo "Running docker detached mode.  Run 'sudo docker ps' to monitor"
    docker run -it \
        -d \
        --env HOSTNAME=$HOSTNAME \
        --env SERVER_PORT=$SERVER_PORT \
        --env NUM_LOOPS=$NUM_LOOPS \
        --env NUM_THREADS=$NUM_THREADS \
        --env THINK_TIME=$THINK_TIME \
        --env TEST_SCRIPT=$TEST_SCRIPT \
        --env TEST_DEBUG=$TEST_DEBUG \
        --label dt-orders-load \
        $FULLIMAGE 
fi
