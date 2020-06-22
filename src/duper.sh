#!/bin/bash

# ENVIRONMENT VARIABLES
# ---------------------
# $SOURCE_REGISTRY
# $SOURCE_IMAGE
# $DESTINATION_REGISTRY
# $DESTINATION_IMAGE
# $TAG

if [ -z "$SOURCE_IMAGE" ] ; then
  echo "ERROR: IMAGE is required"
  exit 1
fi

if [ -z "$DESTINATION_IMAGE" ] ; then
  DESTINATION_IMAGE=$SOURCE_IMAGE
fi

if [ ! -z "$DESTINATION_USER" ] && [ -z $DESTINATION_PASSWORD ] ; then
  echo "Password for $DESTINATION_USER:" 
  read -s DESTINATION_PASSWORD
fi

SOURCE_URI=${SOURCE_REGISTRY:-}$([ ! -z $SOURCE_REGISTRY ] && echo /)$SOURCE_IMAGE:${TAG:-latest}
DESTINATION_URI=${DESTINATION_REGISTRY:-}$([ ! -z $DESTINATION_REGISTRY ] && echo /)$DESTINATION_IMAGE:${TAG:-latest}
docker pull $SOURCE_URI

# login
if [ ! -z "$DESTINATION_USER" ] ; then
  export DOCKER_CONFIG="$(pwd)/.docker"
  echo "$DESTINATION_PASSWORD" | docker login -u $DESTINATION_USER --password-stdin $DESTINATION_REGISTRY
fi

docker images $SOURCE_URI --format "docker tag {{.Repository}}:{{.Tag}} $DESTINATION_URI | docker push $DESTINATION_URI" | bash

# logout
if [ ! -z "$DESTINATION_USER" ] ; then
  docker logout $DESTINATION_REGISTRY
fi
