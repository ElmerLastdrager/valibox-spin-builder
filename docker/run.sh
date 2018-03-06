#!/bin/bash

# Docker scripts for building SPIN
# https://spin.sidnlabs.nl

# Set configuration options
CCACHE_VOLUME=spin.sidnlabs.nl-ccache
LEDE_VOLUME=spin.sidnlabs.nl-lede
DIR="$( cd "$( dirname "${BASH_SOURCE}" )" && pwd )"
DIROUT="$(pwd)"/bin
# env is used to determine the correct executables to run
ENV=/usr/bin/env

# ####################
#        SETUP
# ####################

# -e makes the program exit when any of the lines fail.
# -x prints every line to be executes with a + prefix, to show what we are doing.
set -ex

# Store current working directory
CURDIR=$(pwd)
cd $(dirname $DIR)/../

# ####################
#     DOCKER BUILD
# ####################

# Make sure SPIN container has been built
# TODO: can we check whether it needs to be rebuild? For now: always rebuild
$ENV docker build -t spin.sidnlabs.nl-build -f $DIR/Dockerfile $DIR/..

cd $CURDIR

# ####################
#  CHECK ENVIRONMENT
# ####################

# Make build directory, if it does not exist
if [ ! -d "build" ]; then
    mkdir -p build
fi

# Optional: make cache volume
# TODO Configure ccache (?)
# Create (if needed) docker volume for cache
$env docker volume create $CCACHE_VOLUME

# Docker volume for output
OUTVOL=$(docker volume create)

# ####################
#      BUILD SPIN
# ####################

# Build SPIN using docker
# -v HOSTDIR:Containerdir
$ENV docker run \
    -v $CCACHE_VOLUME:/home/dev/.ccache \
    -v $LEDE_VOLUME:/build/lede_src \
    -v $OUTVOL:/build/lede_src/bin \
    --rm \
    spin.sidnlabs.nl-build

# ####################
#     MOVE OUTPUT
# ####################

# Report output in build directory

docker run \
    --rm \
    -v $OUTVOL:/build/lede_src/bin \
    -v $DIROUT:/output \
    alpine:latest \
    mv /build/lede_src/bin/targets/* /output/

# ####################
#       CLEANUP
# ####################

# Give user command to clear build-containers

# Clear build volume
$ENV docker volume rm $OUTVOL
