#!/bin/bash

# tear down local registry
docker-compose -f registry.yml down
docker-compose -f demo.yml down