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