# Commands executed during YouTube video on enbling Dapr extension for AKS

## Enable k8s-extension for AKS

```bash

az extension add --name k8s-extension

```

## Update k8s-extension for AKS

```bash

az extension update --name k8s-extension

```

## Create Dapr extension and associate with AKS cluster

```bash
az k8s-extension create \
    --cluster-type managedClusters \
    --cluster-name azure-singapore-cluster \
    --resource-group demo-azure-singapore-rg \
    --name myDaprExtension \
    --extension-type Microsoft.Dapr \
    --auto-upgrade-minor-version true

    # --version
```

Dapr version can be specified if we intend to install a specific version. When version is not specified, the latest version is installed.

## Remove dapr extension from AKS cluster

```bash
az k8s-extension delete \
    --cluster-type managedClusters \
    --cluster-name azure-singapore-cluster \
    --resource-group demo-azure-singapore-rg \
    --name myDaprExtension
    
```

## Apply Dapr components

```bash
kubectl apply -R -f k8s/dapr-components/
```

## Deploy TechTalks application
    
```bash
pwsh deployTechTalks-AKS.ps1

```