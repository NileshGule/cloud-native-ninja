# Part 3 Commands

## Build and publish application

```Powershell

dotnet publish --configuration Release --output releaseOutput --no-restore

```

## Build Producer images

### Build image without specifying tag

```powershell

docker build -t producer .

```

### Build image with specific tags

```powershell

docker build -t producer:v1 .

docker build -f .\Dockerfile-v2-TechTalksProducer -t nileshgule/techtalksproducer:v2 .

docker build -f .\Dockerfile-v3-TechTalksProducer -t nileshgule/techtalksproducer:v3 .

docker build -f .\Dockerfile-v4-TechTalksProducer -t nileshgule/techtalksproducer:v4 .

```

## Run container with interactive terminal

```Powershell

docker run --rm `
-it `
--name producer `
-p 5000:80 `
-e ASPNETCORE_ENVIRONMENT=Development `
producer:v1

```

## Run container without attaching to the terminal

```Powershell 

docker run --rm `
-d `
--name producer `
-p 5000:80 `
-e ASPNETCORE_ENVIRONMENT=Development `
producer:v1

```

## Build Consumer image

```Powershell

docker build -f .\Dockerfile-TechTalksConsumer -t nileshgule/techtalksconsumer:dotnet .

```

```Powershell

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