# Commands related to Kubernetes Namespace Demo

## List all namespaces

```bash

kubectl get namespaces

```

## Get all objects in all namespaces

```bash

kubectl get all --all-namespaces

```

## Get all objects in a specific namespace

```bash

kubectl get all -n kube-system

```

## Create a namespace, using imperative commands

```bash

kubectl create namespace techtalks-ns

```

## Create a namespace, using declarative commands

```bash

kubectl apply -f namespace/techtalks-namespace.yaml

```

## Create objects using namespace flag

```bash

kubectl apply -R -f TechTalksProducer/ --namespace techtalks-ns

```

## Create object using declarative syntax with namespace specified in manifest

```bash

kubectl apply -f TechTalksConsumer/consumer-deployment-go.yml

```

## Delete a namespace

```bash

kubectl delete namespace techtalks-ns

```

