resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  address_prefixes     = ["10.0.0.0/19"]
  resource_group_name  = azurerm_resource_group.tfrg.name
  virtual_network_name = azurerm_virtual_network.tfvnet.name
}

