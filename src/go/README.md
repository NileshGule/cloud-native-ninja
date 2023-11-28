# Build

There are 2 ways to build this project.

1. Use `Dockerfile`, including the use of docker compose
2. Use `skaffold` and `ko`.


## Using Skaffold

What is Skaffold?

> _Skaffold is a command line tool that facilitates continuous development for container based & Kubernetes applications.*_

<sup><sub>*https://skaffold.dev/</sub></sup>

It integrates nicely with the following builders:

* Docker
* Cloud Native BuildPacks
* ko
* Jib
* Bazel
* or your Custom build script

What do you need to build this project with Skaffold?
* Download `skaffold` [here are the instructions](https://skaffold.dev/docs/install/)
* Download `ko` [installation instructions here](https://ko.build/)

What is ko?

> _ko is a simple, fast container and secure image builder for Go applications.**_

<sup><sub>** https://ko.build/</sub></sup>

In this project, we will use the `ko` builder type.

This project is already initialized with Skaffold with the `ko` builder type.


At the root of these Go projects (consumer and producer), it comes with `skaffold.yaml`

It is also prepped up with `local` profile to aid the building of images for local development.

**Note: we use the distroless base image**

Why use distroless images?

Taken from [distroless github project](https://github.com/GoogleContainerTools/distroless#why-should-i-use-distroless-images)

> Restricting what's in your runtime container to precisely what's necessary for your app is a best practice employed by Google and other tech giants that have used containers in production for many years. It improves the signal to noise of scanners (e.g. CVE) and reduces the burden of establishing provenance to just what you need.

> Distroless images are very small. The smallest distroless image, gcr.io/distroless/static-debian11, is around 2 MiB. That's about 50% of the size of alpine (~5 MiB), and less than 2% of the size of debian (124 MiB).

### Multi-arch images

Skaffold supports multi-arch images, it is as simple as specifying the `platform` attribute in `skaffold.yaml`
Example:

``` yaml
platforms: ["linux/amd64", "linux/arm64"]
```

### Profiles

Default profile are those `build` sections outside the `profile`.
As a convenience, it is used for local development, where we push and pull from a local registry example: `localhost:32000`

The build will look as simple as this.

``` shell
$ skaffold build
```
Output look similar to this.

``` shell
Generating tags...
 - localhost:32000/techtalksproducer-go -> localhost:32000/techtalksproducer-go:b54ae6f-dirty
 - localhost:32000/techtalksconsumer-go -> localhost:32000/techtalksconsumer-go:b54ae6f-dirty
Checking cache...
 - localhost:32000/techtalksproducer-go: Not found. Building
 - localhost:32000/techtalksconsumer-go: Not found. Building
Starting build...
Building [localhost:32000/techtalksconsumer-go]...
No matching credentials were found, falling back on anonymous
ERRO[0002] gcloud binary not found                      
Using base gcr.io/distroless/base:debug-nonroot@sha256:8bcdf53df65ed93d5606b820c482cd8fe1e1cb74b19eea682b4768f743396b1f for github.com/NileshGule/cloud-native-ninja/consumer
Using build config localhost:32000/techtalksconsumer-go for github.com/NileshGule/cloud-native-ninja/consumer
Building github.com/NileshGule/cloud-native-ninja/consumer for linux/amd64
Publishing localhost:32000/techtalksconsumer-go:b54ae6f-dirty
Published localhost:32000/techtalksconsumer-go:b54ae6f-dirty@sha256:f73a8944f5273432446043768bc520baae1ba5f59b48ea82d705392324bd5468
Build [localhost:32000/techtalksconsumer-go] succeeded
Building [localhost:32000/techtalksproducer-go]...
No matching credentials were found, falling back on anonymous
Using base gcr.io/distroless/base:debug-nonroot@sha256:8bcdf53df65ed93d5606b820c482cd8fe1e1cb74b19eea682b4768f743396b1f for github.com/NileshGule/cloud-native-ninja/producer
Using build config localhost:32000/techtalksproducer-go for github.com/NileshGule/cloud-native-ninja/producer
Building github.com/NileshGule/cloud-native-ninja/producer for linux/amd64
Publishing localhost:32000/techtalksproducer-go:b54ae6f-dirty
Published localhost:32000/techtalksproducer-go:b54ae6f-dirty@sha256:5b144d82f859cc449f7ed30ee24771981421462111367465dd698b577fa0246b
Build [localhost:32000/techtalksproducer-go] succeeded
```

There are 2 other build profiles available.

#### Dockerhub Build

To build for your dockerhub registry

``` shell
$ RELEASE=0.0.1 skaffold build -p dockerhub
```

The output will look similar to this

``` shell
Generating tags...
 - balchu/techtalksproducer-go -> balchu/techtalksproducer-go:b54ae6f-dirty
 - balchu/techtalksconsumer-go -> balchu/techtalksconsumer-go:b54ae6f-dirty
Starting build...
Building [balchu/techtalksconsumer-go]...
Target platforms: [linux/amd64,linux/arm64]
No matching credentials were found, falling back on anonymous
ERRO[0002] gcloud binary not found                      
Using base gcr.io/distroless/base:nonroot@sha256:8bcdf53df65ed93d5606b820c482cd8fe1e1cb74b19eea682b4768f743396b1f for github.com/NileshGule/cloud-native-ninja/consumer
Using build config balchu/techtalksconsumer-go for github.com/NileshGule/cloud-native-ninja/consumer
Building github.com/NileshGule/cloud-native-ninja/consumer for linux/arm64
Using build config balchu/techtalksconsumer-go for github.com/NileshGule/cloud-native-ninja/consumer
Building github.com/NileshGule/cloud-native-ninja/consumer for linux/amd64
Publishing balchu/techtalksconsumer-go:b54ae6f-dirty
Published balchu/techtalksconsumer-go:b54ae6f-dirty@sha256:dcb92a04c33d2fe32c2d8d55aeb60094d1b9c4b1413d634926cb05451230b7bd
Build [balchu/techtalksconsumer-go] succeeded
Building [balchu/techtalksproducer-go]...
Target platforms: [linux/amd64,linux/arm64]
No matching credentials were found, falling back on anonymous
Using base gcr.io/distroless/base:debug-nonroot@sha256:8bcdf53df65ed93d5606b820c482cd8fe1e1cb74b19eea682b4768f743396b1f for github.com/NileshGule/cloud-native-ninja/producer
Using build config balchu/techtalksproducer-go for github.com/NileshGule/cloud-native-ninja/producer
Building github.com/NileshGule/cloud-native-ninja/producer for linux/amd64
Using build config balchu/techtalksproducer-go for github.com/NileshGule/cloud-native-ninja/producer
Building github.com/NileshGule/cloud-native-ninja/producer for linux/arm64
Publishing balchu/techtalksproducer-go:b54ae6f-dirty
Published balchu/techtalksproducer-go:b54ae6f-dirty@sha256:a32a54eec21041492b249646142194b318a6fe5a6b92f393d4f4619bb13aa5a5
```

You will notice that the tag generates a short sha suffixed by `-dirty` b54ae6f-dirty`.  There are a few ways to override the image tag, which you can find in [Tag policies in Skaffold](https://skaffold.dev/docs/taggers/).

For now, we will use the default.

#### ACR Build and push

When releasing to a remote registry, sometimes it is preferred to produce a human readable tag.  In the example below, we will release the image tag named `0.0.1`

To push to a Azure container registry , use the `acr` profile instead.

``` shell
$ RELEASE=0.0.1 skaffold build -p acr
```

To build parallel images, use the argument `--build-concurrency=0`

``` shell
$ RELEASE=0.0.1  skaffold build -p acr --build-concurrency=0

```

The output should look similar to this

``` shell
Generating tags...
 - balchu/techtalksproducer -> balchu/techtalksproducer:0.0.1
 - balchu/techtalksconsumer -> balchu/techtalksconsumer:0.0.1
Starting build...
Building 2 artifacts in parallel
Building [balchu/techtalksconsumer]...
Target platforms: [linux/amd64,linux/arm64]
ERRO[0002] gcloud binary not found                      
Using base gcr.io/distroless/base:debug-nonroot@sha256:8bcdf53df65ed93d5606b820c482cd8fe1e1cb74b19eea682b4768f743396b1f for github.com/NileshGule/cloud-native-ninja/consumer
Using base gcr.io/distroless/base:debug-nonroot@sha256:8bcdf53df65ed93d5606b820c482cd8fe1e1cb74b19eea682b4768f743396b1f for github.com/NileshGule/cloud-native-ninja/producer
Using build config balchu/techtalksproducer for github.com/NileshGule/cloud-native-ninja/producer
Building github.com/NileshGule/cloud-native-ninja/producer for linux/amd64
Using build config balchu/techtalksconsumer for github.com/NileshGule/cloud-native-ninja/consumer
Building github.com/NileshGule/cloud-native-ninja/consumer for linux/arm64
Using build config balchu/techtalksconsumer for github.com/NileshGule/cloud-native-ninja/consumer
Building github.com/NileshGule/cloud-native-ninja/consumer for linux/amd64
Using build config balchu/techtalksproducer for github.com/NileshGule/cloud-native-ninja/producer
Building github.com/NileshGule/cloud-native-ninja/producer for linux/arm64
Publishing index.docker.io/balchu/techtalksconsumer:0.0.1
Publishing index.docker.io/balchu/techtalksproducer:0.0.1
Published index.docker.io/balchu/techtalksconsumer:0.0.1@sha256:dcb92a04c33d2fe32c2d8d55aeb60094d1b9c4b1413d634926cb05451230b7bd
Build [balchu/techtalksconsumer] succeeded

Building [balchu/techtalksproducer]...
Target platforms: [linux/amd64,linux/arm64]
Published index.docker.io/balchu/techtalksproducer:0.0.1@sha256:a32a54eec21041492b249646142194b318a6fe5a6b92f393d4f4619bb13aa5a5
Build [balchu/techtalksproducer] succeeded

```

## Deploy

TODO