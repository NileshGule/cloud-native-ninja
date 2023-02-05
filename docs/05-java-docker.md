# Commands for building Java version

## Docker build commands

```Powershell

docker build -t ngacrregistry.azurecr.io/techtalksconsumer:java .

docker build -t ngacrregistry.azurecr.io/techtalksproducer:java .

```

## Dapr run 

```Powershell

dapr run `
--app-port 8080 `
--app-id java-consumer `
--components-path ../../../Components `
-- java -jar target/techtalks-consumer-0.0.1-SNAPSHOT.jar

dapr run `
--app-port 8081 `
--app-id java-producer `
--components-path ../../../Components `
-- java -jar target/techtalks-producer-0.0.1-SNAPSHOT.jar `
--server.port=8081

```