# Instructions to setup Loki using Helm chart

## Add Grafana helm repo

```code

helm repo add grafana https://grafana.github.io/helm-charts

```

## 

Pre-requisite is to have the kube prometheus stack installed on the Kubernetes cluster. Loki will use Grafana as the visualization tool. 
While installing Loki we need to set the default parameter as flase as Prometheus is already set as the default data source.

```bash

helm upgrade --install loki \
grafana/loki-stack  \
--set loki.isDefault=false \
--wait

```

## Login to Grafana

Expose the Grafana UI on port 3000 and access it using browser [http://localhost:3000](http://localhost:3000)

## Generate logs using the tech talks consumer

Generate logs and check them in Loki browser http://localhost:8080/generate/5000
There will be 5000 messages consumed by the tech talks consumer and each message will write a log entry.

