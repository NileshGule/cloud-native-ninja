# source common variables
. .\var.ps1

Write-Host "Starting deployment of TechTalks Ingress resource to Kuberentes cluster" -ForegroundColor Yellow

Set-Location $nginxIngressRootDirectory
kubectl apply --recursive --filename .

Write-Host "TechTalks Ingress deployed successfully" -ForegroundColor Cyan

Set-Location ~/projects/cloud-native-ninja/Powershell