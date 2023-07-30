# Write-Host "Provisioning AKS cluster with default parameters" -ForegroundColor Cyan
# & ((Split-Path $MyInvocation.InvocationName) + "\initializeAKS.ps1")

Write-Host "Installing RabbitMQ on cluster" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\deployRabbitMQ.ps1")

# Write-Host "Installing KEDA on cluster" -ForegroundColor Cyan
# & ((Split-Path $MyInvocation.InvocationName) + "\deployKEDA.ps1")

Write-Host "Installing Dapr on cluster" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\deploy-dapr.ps1")

Write-Host "Installing Autoscalar on cluster" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\deployAutoScaler.ps1")

Write-Host "Installing Dapr components on cluster" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\deployDaprComponents.ps1")

Write-Host "Installing TechTalks application on cluster" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\deployTechTalks-AKS.ps1")

