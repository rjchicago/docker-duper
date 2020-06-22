# docker-duper

Welcome to **Docker-Duper**!

**Docker-Duper** is a self-contained image to facilitate duplicating Docker images from one registry to another.

## Supported Variables

| Required | Variable             | Description                                                                           |
|:--------:|----------------------|---------------------------------------------------------------------------------------|
|          | SOURCE_REGISTRY      | Source Registry. If not supplied, defaults to Docker Hub.                             |
|     *    | SOURCE_IMAGE         | Source Image. i.e. `alpine` or `rjchicago/docker-duper`                               |
|          | DESTINATION_REGISTRY | Destination Registry. i.e. `localhost:5000`. If not supplied, defaults to Docker Hub. |
|          | DESTINATION_IMAGE    | Destination Image. If not supplied, defaults to $SOURCE_IMAGE                         |
|          | DESTINATION_USER     | Destination Registry User.                                                            |
|          | DESTINATION_PASSWORD | Destination Registry Password.                                                        |
|          | TAG                  | Tag to copy. If not supplied, defaults to `latest`.                                   |

## Example

The following will copy `alpine:edge` from Alpine's official `Docker Hub` repo to `localhost:5000`:

``` sh
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e IMAGE="alpine" \
  -e TAG=edge \
  -e DESTINATION_REGISTRY="localhost:5000" \
  rjchicago/docker-duper
```

> **NOTE**: update `localhost:5000` with your registry

The following will copy `alpine:edge` from Alpine's official `Docker Hub` repo to my personal `Docker Hub` repo:

``` sh
USER=rjchicago
IMAGE=alpine
TAG=3.12
docker run --rm -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e SOURCE_IMAGE="$IMAGE" \
  -e DESTINATION_IMAGE="$USER/$IMAGE" \
  -e DESTINATION_USER="$USER" \
  -e TAG="$TAG" \
  rjchicago/docker-duper sh
```

The following will copy `alpine:edge` from Alpine's official `Docker Hub` repo to a private `DTR` repo:

``` sh
DTR=dtr.cnvr.net
IMAGE=alpine
TAG=3.12
docker run --rm -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e SOURCE_IMAGE="$IMAGE" \
  -e DESTINATION_REGISTRY="$DTR" \
  -e DESTINATION_IMAGE="$(whoami)/$IMAGE" \
  -e DESTINATION_USER="$(whoami)" \
  -e TAG="$TAG" \
  rjchicago/docker-duper sh
```

## docker-duper demo

### <a name="note-insecure-registries"></a>Note on Insecure Registries

In order to run the demo, you will need to update your Docker insecure registries:
https://docs.docker.com/registry/insecure/

For this demo, add `localhost:5000`

### <a name="demo-up"></a>Demo Up

To run the full demo, clone this repo and run the following script:

``` sh
sh demo\demo-up.sh
```

The demo will spin up a registry and copy in a couple of images.

Lastly, the demo should pop open a Web browser to <a href="http://localhost:8080" target="_blank">http://localhost:8080</a>

### <a name="demo-down"></a>Demo Down

To complete and end the demo, run the following script:

``` sh
sh demo\demo-down.sh
```

## single purpose containers

### <a name="docker-run"></a>Docker Run

You can run single purpose containers to copy images as needed.

An official image of `docker-duper` is available on Docker Hub:

* https://hub.docker.com/r/rjchicago/docker-duper

For this example, we'll run the local registry (see note on [insecure registries](#note-insecure-registries)):

``` sh
docker-compose -f  docker-registry.yml up -d
```

Next, we'll run a single purpose container to copy `docker-duper` to our registry:

``` sh
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e IMAGE="rjchicago/docker-duper" \
  -e DESTINATION_REGISTRY="localhost:5000" \
  rjchicago/docker-duper
```

Preview your registry at <a href="http://localhost:8080" target="_blank">http://localhost:8080</a>

Now let's copy over the `alpine:latest` and `alpine:edge` images:

``` sh
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e IMAGE="alpine" \
  -e DESTINATION_REGISTRY="localhost:5000" \
  rjchicago/docker-duper
```

``` sh
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e IMAGE="alpine" \
  -e TAG=edge \
  -e DESTINATION_REGISTRY="localhost:5000" \
  rjchicago/docker-duper
```

When you're done, don't forget to compose down the demo registry:

``` sh
docker-compose -f  docker-registry.yml down
```
