# Commands related to interacting with Docker Hub

## Login

```Powershell

docker login

```

## Logout

```Powershell

docker logout

```

## Push

```Powershell

docker push nileshgule/techtalksproducer:dotnet

docker push nileshgule/techtalksconsumer:dotnet

```

## Pull
    
```Powershell

docker pull nileshgule/techtalksproducer:dotnet

docker pull nileshgule/techtalksconsumer:dotnet

```

## Push multiple images using docker compose

```Powershell

docker-compose -f docker-compose-dockerhub.yml push

```

## Pull multiple images using docker compose

```Powershell

docker-compose -f docker-compose-dockerhub.yml pull

```
