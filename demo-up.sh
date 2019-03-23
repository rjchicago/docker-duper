#!/bin/bash

# spin up local registry
docker-compose -f registry.yml up -d

# build and push
DOCKER_DUPER_TAG=localhost:5000/rjchicago/docker-duper
docker build ./src
docker tag $DOCKER_DUPER_TAG
docker push $DOCKER_DUPER_TAG

# run docker-duper demo
docker-compose -f demo.yml up -d

# launch registry ui
sleep 2 && python -mwebbrowser http://localhost:8080