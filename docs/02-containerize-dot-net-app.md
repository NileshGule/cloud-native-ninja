# Dapr commands

```powershell

dapr init

dapr run `
--app-id techtalks-producer `
--components-path ../../../dapr-components/ `
--app-port 5001 `
-- dotnet run


dapr run `
--app-id consumer `
--components-path ../../../Components/ `
--app-port 5000 `
--dapr-http-port 3500 `
-- dotnet run

dapr run `
--app-id checkout `
--components-path ../../Components `
--app-port 5000 `
--dapr-http-port 3500 `
--dapr-grpc-port 60002 `
dotnet run

```
