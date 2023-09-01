#################
## Create Vnet ##
#################
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location              = var.location
  resource_group_name   = var.resource_group_name
}
###################
## Create Subnet ##
###################
resource "azurerm_subnet" "proj_subnet" {
  name                 = var.subnet
  resource_group_name   = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}