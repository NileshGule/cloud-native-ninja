resource "azurerm_resource_group" "tfrg" {
  name     = var.resource_group_name  #"tfResourceGroup"
  location = var.resource_group_location #"Australia Southeast"
}