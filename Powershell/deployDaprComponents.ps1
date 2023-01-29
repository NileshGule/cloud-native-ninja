# source common variables
. .\var.ps1

Write-Host "Starting deployment of Dapr Components to Kuberentes cluster" -ForegroundColor Yellow

Set-Location $daprComponentsRootDirectory
kubectl apply --recursive --filename .

Write-Host "Dapr Components deployed successfully" -ForegroundColor Cyan

Set-Location ~/projects/cloud-native-ninja/Powershell