# Getting started

Clone this project.

## Requirements
Follow instructions on how to [install dapr](https://docs.dapr.io/getting-started/).

Install [`chef`](https://github.com/LukeMathWalker/cargo-chef), it is _Cache the dependencies of your Rust project and speed up your Docker builds._

``` shell
cargo install cargo-chef
```

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
cd publisher
cargo run 
```

The Consumer

```shell
cd subscriber
cargo run 
```

With dapr cli

```shell
cd publisher
dapr run --app-id producer-rs --resources-path ../component-resource -- cargo run
```

```shell
cd subscriber
dapr run --app-id subscriber-rs --app-port 50051 --app-protocol grpc --resources-path ../component-resource -- cargo run
```

Using Docker


```shell
cd publisher
docker build -t localhost:32000/producer-rs:0.0.0 .
```

```shell
cd subscriber
docker build -t localhost:32000/subscriber-rs:0.0.0 .
```


## Deploying to kubernetes

Make sure that dapr is installed into your kubernetes cluster.  The example will be deployed onto the `default` namespace.

```shell

# deploy the component
# check the content of the file component-resource/pubsub.yaml and align with the rabbitmq connection
kubectl apply -f component-resource/

# Deploy the publisher
kubectl apply -f publisher/k8s/

# Deploy the subscriber
kubectl apply -f subscriber/k8s/

```
## Testing

Publishing messages to RabbitMQ, assuming that the http port of the publisher is on `8080`

```shell
curl --request POST \
  --url http://localhost:8080/generate/ \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data max_messages=150
```  

Sample output from the subscriber

```shell
. . .
ID: 143
Name: Getting started with Rust - talk id 143
Level ID: 17670199691767572000
Content-Type: application/json
Category ID: 13391924940439720000
ID: 144
Name: Getting started with Rust - talk id 144
Level ID: 5188078044088092000
Content-Type: application/json
Category ID: 4665489211947467000
ID: 145
Name: Getting started with Rust - talk id 145
Level ID: 13624757491874765000
Content-Type: application/json
Category ID: 17443969959438152000
ID: 146
Name: Getting started with Rust - talk id 146
Level ID: 17091200595655449000
Content-Type: application/json
Category ID: 15390673550429307000
ID: 147
Name: Getting started with Rust - talk id 147
Level ID: 1077350143350605200
Content-Type: application/json
Category ID: 13352562419077702000
ID: 148
Name: Getting started with Rust - talk id 148
Level ID: 15158588535690630000
Content-Type: application/json
Category ID: 15938525462195302000
ID: 149
Name: Getting started with Rust - talk id 149
Level ID: 1162455077349897000
Content-Type: application/json
. . .

```
