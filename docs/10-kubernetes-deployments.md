# Commands related to working with Kubernetes deployments

## Create a deployment

```bash

kubectl create deployment techtalks-producer-deployment --image=nileshgule/techtalksproducer:go

```

## Verify deployment using `Tree` plugin

```bash

kubectl tree deployment techtalks-producer-deployment

```

## Port forward to deployment

```bash

kubectl port-forward deployment/techtalks-producer-deployment 8080:8080

```

## Delete deployment

```bash

kubectl delete deployment techtalks-producer-deployment

```

## Create deployment with `2 replicas`

```bash

kubectl create deployment techtalks-producer-deployment --image=nileshgule/techtalksproducer:go --replicas=2

```

## Delete one of the pods and see if it gets recreated

```bash

kubectl delete pod techtalks-producer-deployment-565c96c4d-d4msk

```

## Get events related to deployment

```bash

kubectl get events --field-selector involvedObject.name=techtalks-producer-deployment

```

## Scale deployment to `5 replicas`

```bash

kubectl scale deployment techtalks-producer-deployment --replicas=5

```

## Create deployment using manifest file

```bash

kubectl create -f producer-deployment.yaml

```

## Create / update deployment using `apply` command

```bash

kubectl apply -f producer-deployment.yaml

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

