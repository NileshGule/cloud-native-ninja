# Docker compose commands

## Legacy `docker-compose` commands

```Powershell

docker-compose version

docker-compose up

docker-compose ps

docker-compose -f .\docker-compose-dockerhub.yml up

docker-compose -f .\docker-compose-dockerhub.yml up -d

docker-compose -f .\docker-compose-dockerhub.yml down

docker-compose -f .\docker-compose-dockerhub.yml build

docker-compose -f .\docker-compose-dockerhub.yml build techtalks.producer

```

## Docker compose `version`

```Powershell

docker compose version

```

## `Docker compose up` with default compose file

```Powershell

docker compose up

```

## List running containers using `Docker compose ps`

```Powershell

docker compose ps

```

## Docker compose up with `custom compose file`

```Powershell

docker compose -f .\docker-compose-dockerhub.yml up

```

## Docker compose up with custom compose file in `detached mode`

```Powershell

docker compose -f .\docker-compose-dockerhub.yml up -d

```

## Docker compose `down`

```Powershell

docker compose down

```

## Docker compose `down with custom compose file`

```Powershell

docker compose -f .\docker-compose-dockerhub.yml down

```

## Docker compose `build with custom compose file`

```Powershell

docker compose -f .\docker-compose-dockerhub.yml build

```

## Docker compose `build with custom file and specific service`

```Powershell

docker compose -f .\docker-compose-dockerhub.yml build techtalks.producer

```

## Docker compose `up with multiple files`

```Powershell

docker compose `
-f .\docker-compose.yml `
-f .\docker-compose-dockerhub.yml up

```