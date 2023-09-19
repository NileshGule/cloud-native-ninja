# Add the Helm chart for Nginx Ingress
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Install the Helm (v3) chart for nginx ingress controller
# (If using Bash instead of Powershell, replace ` with \)
Write-Host "Installing Nginx ingress controller on AKS cluster $clusterName" -ForegroundColor Green

#Helm 3 syntax
helm upgrade --install `
    app-ingress ingress-nginx/ingress-nginx 
    # --create-namespace `
    # --namespace ingress

Set-Location ~/projects/cloud-native-ninja/Powershell
