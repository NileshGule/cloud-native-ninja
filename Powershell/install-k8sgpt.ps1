helm repo add k8sgpt https://charts.k8sgpt.ai/
helm repo update

helm upgrade --install k8sgpt `
k8sgpt/k8sgpt-operator -n k8sgpt-operator-system `
--create-namespace `
--set serviceMonitor.enabled=true `
--set grafanaDashboard.enabled=true `
--wait
