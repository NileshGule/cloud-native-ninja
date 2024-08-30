resource "helm_release" "techtalks" {
  name = "techtalks"

  repository       = "../techtalks-helm-chart"
  chart            = "techtalk"
  version          = "0.1.0"

  depends_on = [ helm_release.rabbitmq, helm_release.keda ]
}