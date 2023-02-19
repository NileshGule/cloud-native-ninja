# Commands for building Go version

## Docker build commands

```Powershell

docker build -t nileshgule/techtalksconsumer:go .

docker build -t nileshgule/techtalksproducer:go .

```

## Docker compose commands

```Powershell

docker-compose -f docker-compose-go-dockerhub.yml build

docker-compose -f docker-compose-go-dockerhub.yml push

```

## Dapr run 

```Powershell

dapr run `
--app-port 8080 `
--app-id go-consumer `
--components-path ../../../Components `
-- go run .

dapr run `
--app-port 8081 `
--app-id java-producer `
--components-path ../../../Components `
-- go run .

```

## Docker run commands

```Powershell

docker run --rm `
-it `
--name techtalksproducer `
-p 8081:8080 `
nileshgule/techtalksproducer:go


docker run --rm `
-it `
--name techtalksconsumer `
-p 8080:8080 `
nileshgule/techtalksconsumer:go

```