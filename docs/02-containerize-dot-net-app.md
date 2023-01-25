# Dapr commands

```powershell

dapr init

dapr run `
--app-id consumer `
--components-path ../../../Components/ `
--app-port 6000 `
-- dotnet run

dapr run `
--app-id producer `
--components-path ../../../Components/ `
--app-port 5000 `
-- dotnet run

docker run --rm `
-it `
--name techtalksproducer `
-p 5000:80 `
-e ASPNETCORE_ENVIRONMENT=Development `
ngacrregistry.azurecr.io/techtalksproducer:dotnet

```

## Docker Commands

```powershell

docker build -f .\Dockerfile-TechTalksProducer -t nileshgule/techtalksproducer:dotnet .

docker build -f .\Dockerfile-TechTalksConsumer -t nileshgule/techtalksconsumer:dotnet .

docker run --rm `
-it `
--name techtalksproducer `
-p 5000:80 `
-e ASPNETCORE_ENVIRONMENT=Development `
ngacrregistry.azurecr.io/techtalksproducer:dotnet

```