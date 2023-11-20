# Commands related to Docker Compose `include` directive

## List existing container images

```bash

docker images

```

## Run Docker Compose with `include` directive

```bash

docker-compose -f docker-compose-dotnet-acr-include.yml build techtalks.producer

docker-compose -f docker-compose-dotnet-acr-include.yml build 



```

## Run services using Docker Compose

```bash 

docker-compose -f docker-compose-dotnet-acr-include.yml up -d

```

## Shut down services using Docker Compose

```bash

docker-compose -f docker-compose-dotnet-acr-include.yml down

```