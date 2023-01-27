# Part 3 Commands

## Build and publish application

```Powershell

dotnet publish --configuration Release --output releaseOutput --no-restore

```

```powershell

docker build -t producer .

docker run --rm `
-it `
--name producer `
-p 5000:80 `
-e ASPNETCORE_ENVIRONMENT=Development `
producer

docker build -f .\Dockerfile-TechTalksProducer -t nileshgule/techtalksproducer:dotnet .

docker build -f .\Dockerfile-TechTalksConsumer -t nileshgule/techtalksconsumer:dotnet .

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
nileshgule/techtalksproducer:dotnet

```