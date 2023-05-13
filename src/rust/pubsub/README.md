# Getting started

Clone this project.

## Requirements
Follow instructions on how to [install dapr](https://docs.dapr.io/getting-started/).

## Install Rabbitmq

```shell
helm upgrade --namespace rabbitmq --install rabbit oci://registry-1.docker.io/bitnamicharts/rabbitmq
```

The chart will autogenerate the password.  In order to get the password, execute the command below.

```shell
echo "Password      : $(kubectl get secret --namespace rabbitmq rabbit-rabbitmq -o jsonpath="{.data.rabbitmq-password}" | base64 -d)"
```

Expose the port using port-forwarding

```shell
kubectl port-forward --namespace rabbitmq svc/rabbit-rabbitmq 5672:5672
```
## Dapr component configuration

```yaml
apiVersion: dapr.io/v1alpha1
kind: Component
metadata:
  name: rabbitmq-pubsub
spec:
  type: pubsub.rabbitmq
  version: v1
  metadata:
  - name: host
    value: "amqp://localhost:5672"
  - name: durable
    value: "false"
  - name: deletedWhenUnused
    value: "false"
  - name: autoAck
    value: "false"
  - name: reconnectWait
    value: "0"
  - name: concurrency
    value: parallel
scopes:
  - techtalks
```

## Components

* Producer - Will run and publish `10000` messages to the `techtalks` topic.
* Consumer - Simply consume the messages and print them to the console.

The data structure of the message looks something like this

```json
{"CatergoryId":15060491017926663151,"LevelId":6879121891696257169,"TechTalkName":"Getting started with Rust - talk id 0","id":0}
```

## Build

Run locally

The Producer

``` shell
cargo run --bin producer
```

The Consumer

```shell
cargo run --bin consumer
```

With dapr cli

```shell
dapr run --app-id rust-producer --resources-path ./component-resource -- cargo run --bin producer
```

```shell
dapr run --app-id rust-consumer --app-port 50051 --app-protocol grpc --resources-path ./component-resource -- cargo run --bin consumer
```