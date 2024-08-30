data "azurerm_kubernetes_cluster" "this" {
  name                = var.k8s_cluster_name
  resource_group_name = var.resource_group_name

  # Comment this out if you get: Error: Kubernetes cluster unreachable 
  depends_on = [azurerm_kubernetes_cluster.this]
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.this.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)
  }
}

resource "helm_release" "external_keda" {
  name = "external"

  repository       = "https://kedacore.github.io/charts"
  chart            = "keda"
  namespace        = "keda"
  create_namespace = true
  version          = "2.12.1"
 
}

resource "helm_release" "rabbitmq" {
  name = "rabbitmq"

  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "rabbitmq"
  version          = "10.2.1"

  set {
    name  = "auth.username"
    value = "user"
  }

  set {
    name  = "auth.password"
    value = "PASSWORD"
  }

  set {
    name  = "auth.erlangCookie"
    value = "c2VjcmV0Y29va2ll"
  }
 
}

resource "helm_release" "techtalks" {
  name = "techtalks"

  repository       = "../techtalks-helm-chart"
  chart            = "techtalk"
  version          = "0.1.0"
 
}