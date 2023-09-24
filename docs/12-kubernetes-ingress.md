# Commands related to Kubernetes Ingress Demo

## Deploy NGINX Ingress Controller with Helm using a Powershell script

Run the [Powershell script - deploy-nginx.ps1](../Powershell/deploy-nginx.ps1) to deploy the NGINX Ingress Controller.

``` powershell

pwsh deploy-nginx.ps1

```

## Verify the installation
Verify that the Ingress Controller is running by checking the pods and service.

``` powershell

kubectl get pods

kubectl get service/app-ingress-ingress-nginx-controller -o yaml

```


## Deploy Ingress Resources

Run the [Powershell script - deploy-techtalks-ingress.ps1](../Powershell/deploy-techtalks-ingress.ps1) to deploy the Ingress resources.

``` powershell
