#!/bin/bash

# ENVIRONMENT VARIABLES
# ---------------------
# $SOURCE_REGISTRY
# $DESTINATION_REGISTRY
# $IMAGE
# $TAG

if [ -z "$IMAGE" ] ; then
  echo "ERROR: IMAGE is required"
  exit 1
fi

if [ -z "$DESTINATION_REGISTRY" ] ; then
  echo "ERROR: DESTINATION_REGISTRY is required"
  exit 1
fi

SOURCE_URI=${SOURCE_REGISTRY:-}$([ ! -z $SOURCE_REGISTRY ] && echo /)$IMAGE:${TAG:-latest}
DESTINATION_URI=${DESTINATION_REGISTRY:-}/$IMAGE:${TAG:-latest}

docker pull $SOURCE_URI
docker images $SOURCE_URI --format "docker tag {{.Repository}}:{{.Tag}} $DESTINATION_URI | docker push $DESTINATION_URI" | bash

exit 0