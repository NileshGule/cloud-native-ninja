# Commands related to the first part of the Cloud Native Ninja series

## Basic Docker commands

```powershell

docker version

docker --help

docker ps

docker images

docker container ls

docker container ls -a

```

## Docker commands to run RabbitMQ container

```powershell

docker run --rm -it --hostname rabbitmq --name techtalks-rabbit -p 5672:5672 -p 15672:15672 rabbitmq:3-management

podman run --rm -it --hostname rabbitmq --name techtalks-rabbit -p 5672:5672 -p 15672:15672 docker.io/rabbitmq:3-management

docker rm techtalks-rabbit

```

## Docker command to override RabbitMQ default password

```powershell

docker run -d --hostname rabbitmq `
--name techtalks-rabbit `
-p 5672:5672 `
-p 15672:15672 `
-e RABBITMQ_DEFAULT_USER=avatar `
-e RABBITMQ_DEFAULT_PASS=JamesBond007 `
rabbitmq:3-management

```