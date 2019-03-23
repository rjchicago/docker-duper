# docker-duper

Welcome to **Docker-Duper**!

**Docker-Duper** is a self-contained image to facilitate copying images from one registry to another.

The following environment variables are supported:

| Required | Variable             | Description                                                     |
|:--------:|----------------------|-----------------------------------------------------------------|
|          | SOURCE_REGISTRY      | Registry to copy from. If not supplied, defaults to Docker Hub. |
|     *    | DESTINATION_REGISTRY | Registry to copy to. i.e. `localhost:5000`                      |
|     *    | IMAGE                | Image to copy. i.e. `alpine` or `rjchicago/docker-duper`        |
|          | TAG                  | Tag to copy. If not supplied, defaults to `latest`.             |

### Example

```
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e IMAGE='alpine' \
  -e TAG=edge \
  -e DESTINATION_REGISTRY='localhost:5000' \
  rjchicago/docker-duper
```

## <a href="note-insecure-registries"></a>Note on Insecure Registries:
In order to run the demo, you will need to update your Docker insecure registries:
https://docs.docker.com/registry/insecure/

For this demo, add `localhost:5000`


## <a href="demo-up"></a>Demo Up
To run the full demo, clone this repo and run the following script:

```
sh demo-up.sh
```

The demo will spin up a registry and copy in a couple of images.

Lastly, the demo should pop open a Web browser to <a href="http://localhost:8080" target="_blank">http://localhost:8080</a>


## <a href="demo-down"></a>Demo Down
To complete and end the demo, run the following script:

```
sh demo-down.sh
```


## <a href="docker-run"></a>Docker Run
You can run single purpose containers to copy images as needed. An official image of `docker-duper` is available on Docker Hub:
* https://hub.docker.com/r/rjchicago/docker-duper

For this example, we'll run the local registry (see note on [insecure registries](#note-insecure-registries)):

```
docker-compose -f registry.yml up -d
```

Next, we'll run a single purpose container to copy `docker-duper` to our registry:

```
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e IMAGE='rjchicago/docker-duper' \
  -e DESTINATION_REGISTRY='localhost:5000' \
  rjchicago/docker-duper
```

Preview your registry at <a href="http://localhost:8080" target="_blank">http://localhost:8080</a>

Now let's copy over the `alpine:latest` and `alpine:edge` images:

```
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e IMAGE='alpine' \
  -e DESTINATION_REGISTRY='localhost:5000' \
  rjchicago/docker-duper

docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e IMAGE='alpine' \
  -e TAG=edge \
  -e DESTINATION_REGISTRY='localhost:5000' \
  rjchicago/docker-duper
```


When you're done, don't forget to compose down the demo registry:

```
docker-compose -f registry.yml down
```
