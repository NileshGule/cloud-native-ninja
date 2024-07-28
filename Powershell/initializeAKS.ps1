Param(
    [parameter(Mandatory = $false)]
    [string]$subscriptionName = "Microsoft Azure Sponsorship",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "demo-azure-melbourne-rg",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupLocaltion = "australiasoutheast",
    [parameter(Mandatory = $false)]
    [string]$clusterName = "azure-melbourne-cluster",
    [parameter(Mandatory = $false)]
    [int16]$workerNodeCount = 3,
    [parameter(Mandatory = $false)]
    [string]$kubernetesVersion = "1.29.5",
    [parameter(Mandatory = $false)]
    [string]$acrRegistryName = "ngAcrRegistry"
)

# Set Azure subscription name
Write-Host "Setting Azure subscription to $subscriptionName"  -ForegroundColor Yellow
az account set --subscription=$subscriptionName

$aksRgExists = az group exists --name $resourceGroupName

Write-Host "$resourceGroupName exists : $aksRgExists"

if ($aksRgExists -eq $false) {

    # Create resource group name
    Write-Host "Creating resource group $resourceGroupName in region $resourceGroupLocaltion" -ForegroundColor Yellow
    az group create `
        --name=$resourceGroupName `
        --location=$resourceGroupLocaltion `
        --output=jsonc
}

$aks = az aks show `
    --name $clusterName `
    --resource-group $resourceGroupName `
    --query name | ConvertFrom-Json

$aksCLusterExists = $aks.Length -gt 0

if ($aksCLusterExists -eq $false) {
    # Create AKS cluster
    Write-Host "Creating AKS cluster $clusterName with resource group $resourceGroupName in region $resourceGroupLocaltion" -ForegroundColor Yellow
    az aks create `
        --resource-group=$resourceGroupName `
        --name=$clusterName `
        --node-count=$workerNodeCount `
        --enable-managed-identity `
        --generate-ssh-keys `
        --output=jsonc `
        --kubernetes-version=$kubernetesVersion `
        --attach-acr=$acrRegistryName `
        --enable-keda

    #check the status of last command
    if (!$?) {
        Write-Error "Error creating ASK cluster" -ErrorAction Stop
    }

}
# Get credentials for newly created cluster
Write-Host "Getting credentials for cluster $clusterName" -ForegroundColor Yellow
az aks get-credentials `
    --resource-group=$resourceGroupName `
    --name=$clusterName `
    --overwrite-existing

Write-Host "Successfully created cluster $clusterName with $workerNodeCount node(s)" -ForegroundColor Green

Set-Location ~/projects/cloud-native-ninja/Powershell

# az vm create `
#     --resource-group demo-azure-singapore-rg `
#     --name rabbitmq-new `
#     --admin-username azureuser `
#     --generate-ssh-keys `
#     --image bitnami:rabbitmq:rabbitmq:latest `
#     --plan-name rabbitmq `
#     --plan-product rabbitmq `
#     --plan-publisher bitnami `
#     --public-ip-sku Standard

# az vm open-port --port 5672 --name rabbitmq-new  `
#     --resource-group demo-azure-singapore-rg

# az vm open-port --port 15672 --name rabbitmq-new `
#     --resource-group demo-azure-singapore-rg --priority 1100