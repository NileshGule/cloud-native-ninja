# Steps to setup the k8sgpt operator on a Kubernetes cluster

## Prerequisites

- A Kubernetes cluster 
- Install Prometheus using Kube stack operator: Ensure that the `serviceMonitorSelectorNilUsesHelmValues` is set to `false` in the `values.yaml` file of the kube-prometheus-stack helm chart. This is required to enable the prometheus operator to discover the service monitors created by the k8sgpt operator. This can also be done by using the following command:
```
helm upgrade --install prometheus \
prometheus-community/kube-prometheus-stack  \
--set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
--wait

```

## Steps

1. Install the k8sgpt operator using the following command:
```

helm repo add k8sgpt https://charts.k8sgpt.ai/
helm repo update

helm upgrade --install k8sgpt `
k8sgpt/k8sgpt-operator -n k8sgpt-operator-system `
--create-namespace `
--set serviceMonitor.enabled=true `
--set grafanaDashboard.enabled=true `
--wait

```

Note that we are enabling the service monitor and grafana dashboard in the above command. This is required to enable the prometheus operator to discover the service monitors created by the k8sgpt operator. Also a default grafana dashboard is created by the k8sgpt operator to monitor the k8sgpt operator.

2. Store the Azure openAI API key in an environment variable. This is required to create a Kubernetes secret with the Azure OpenAI API key. The environment variable can be set using the following command:

```
export AZURE_OPENAI_TOKEN=<<>> # Replace <<>> with the Azure OpenAI API key

``` 

3. Create a Kubernetes secret with the Azure OpenAI API key. This is required to access the Azure OpenAI API. The secret can be created using the following command:
```

kubectl create secret generic k8sgpt-azure-openai-secret --from-literal=azure-openai-api-key=$AZURE_OPENAI_TOKEN -n k8sgpt-operator-system

```

4. Create a k8sgpt custom resource to create a k8sgpt model. The custom resource can be created using the following command:

```

kubectl apply -R -f k8s/k8sgpt/

```

This will apply the k8sgpt-config.yaml file and create a CRD for k8sgpt in the cluster. Make sure the contents of the file are correct before applying it. Following values need to match what is specified in the Azure OpenAI service and the deployment created withing the Azure AI studio:
- `model`
- `backend`
- `baseUrl`
- `engine`
- `secret name` and `secret key` should match the secret created in the previous step

With all these steps completed, the k8sgpt operator should be up and running and the k8sgpt model should be created. The k8sgpt model results can be accessed using the following command:

```

kubectl get results 

```