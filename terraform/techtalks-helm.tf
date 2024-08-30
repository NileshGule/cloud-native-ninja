resource "helm_release" "techtalks" {
  name = "techtalks"

  repository       = "../techtalks-helm-chart"
  chart            = "techtalk"
  version          = "0.1.0"

  depends_on = [ azurerm_kubernetes_cluster.this, helm_release.rabbitmq, helm_release.keda ]
}