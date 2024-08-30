
resource "azurerm_kubernetes_cluster" "this" {
  name                = var.k8s_cluster_name
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name
  dns_prefix          = "devaks1"

  kubernetes_version        = var.k8s_version
  automatic_upgrade_channel = "stable"
  private_cluster_enabled   = false
  node_resource_group       = "${var.resource_group_name}-${var.k8s_cluster_name}"

  # For production change to "Standard" 
  sku_tier = "Free"

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  network_profile {
    network_plugin = "azure"
    dns_service_ip = "10.0.64.10"
    service_cidr   = "10.0.64.0/19"
  }

  default_node_pool {
    name                 = "general"
    vm_size              = "Standard_D2_v2"
    vnet_subnet_id       = azurerm_subnet.subnet1.id
    orchestrator_version = var.k8s_version
    type                 = "VirtualMachineScaleSets"
    auto_scaling_enabled  = false
    node_count           = var.k8s_worker_node_count
  }

  identity {
    type = "SystemAssigned"
  }
    
}

# module "aks_addons" {
#   source                                        = "squareops/aks-addons/azurerm"
#   environment                                   = "dev"
#   name                                          = "aks-addons"
#   aks_cluster_name                              = var.k8s_cluster_name
#   resource_group_name                           = var.resource_group_name
#   resource_group_location                       = var.resource_group_location
#   keda_enabled                                  = true
# }

resource "azurerm_kubernetes_cluster_extension" "dapr-extension" {
  name           = "dapr"
  cluster_id     = azurerm_kubernetes_cluster.this.id
  extension_type = "microsoft.dapr" #"microsoft.flux"

}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.this.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.this.kube_config_raw

  sensitive = true
}