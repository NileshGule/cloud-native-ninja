resource "azurerm_virtual_network" "tfvnet" {
  name                = "main"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name

}