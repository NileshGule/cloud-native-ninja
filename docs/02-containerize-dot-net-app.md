# Dapr commands

```powershell

dapr init

dapr run `
--app-id consumer `
--components-path ../../../Components/local `
--app-port 6000 `
-- dotnet run

dapr run `
--app-id producer `
--components-path ../../../Components/local `
--app-port 5000 `
-- dotnet run

docker run --rm `
-it `
--name techtalksproducer `
-p 5000:80 `
-e ASPNETCORE_ENVIRONMENT=Development `
ngacrregistry.azurecr.io/techtalksproducer:dotnet


docker run --rm `
-it `
--name techtalksproducer `
-p 5000:80 `
-e ASPNETCORE_ENVIRONMENT=Development `
nileshgule/techtalksproducer

```

