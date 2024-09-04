# Commands related to working with Kubernetes `Service`

## Create a service help

```bash

kubectl create service --help

```

## Create / update Service using `create / apply` command

```bash

kubectl create -f producer-service.yml

kubectl apply -f producer-service.yml

```

## Get all services

```bash

kubectl get service

kubectl get services

kubectl get svc

```

## Verify Service using `Tree` plugin

```bash

kubectl tree service rabbitmq-producer-service

```

## Describe Service

```bash

kubectl describe service rabbitmq-producer-service

kubectl describe svc rabbitmq-producer-service

```

## Port forward to Service

```bash

kubectl port-forward service/rabbitmq-producer-service 8080:8080

kubectl port-forward svc/rabbitmq-producer-service 8080:8080

```

## Delete service

```bash

kubectl delete service rabbitmq-producer-service

kubectl delete -f producer-service.yml

```

## Verify deployment is still running

```bash

kubectl get deployment

```


## Kubectl apply all files in a directory

```bash
kubectl apply --recursive --filename .

kubectl apply -R -f .

``` 

## Delete all Kubernetes objects recursively in a directory

```bash
kubectl delete --recursive --filename .

kubectl delete -R -f .

```

