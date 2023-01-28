# Commands for building Java version

## Dapr run 

```Powershell

dapr run `
--app-port 8080 `
--app-id java-consumer `
--components-path ../../../Components `
-- java -jar target/techtalks-consumer-0.0.1-SNAPSHOT.jar

```