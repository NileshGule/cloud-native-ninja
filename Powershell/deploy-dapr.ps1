helm repo add dapr https://dapr.github.io/helm-charts

helm repo update

Write-Host "Initializing Dapr on AKS cluster $clusterName" -ForegroundColor Green

#Helm 3 syntax
helm upgrade --install dapr `
dapr/dapr `
--version 1.9.5 `
--create-namespace `
--namespace dapr-system `
--wait


Set-Location ~/projects/cloud-native-ninja/Powershell
