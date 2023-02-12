# Dapr commands to run Go application

```powershell

dapr run `
--app-id consumer `
--components-path ../../../Components/local `
--app-port 8081 `
-- dotnet run

dapr run `
--app-id producer `
--components-path ../../../Components/local `
--app-port 8080 `
-- dotnet run

```