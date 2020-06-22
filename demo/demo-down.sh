#!/bin/bash

# tear down local registry
docker-compose -f  docker-registry.yml down
docker-compose -f  docker-demo.yml down