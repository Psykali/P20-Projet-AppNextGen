resource "azurerm_virtual_network" "vnet" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location              = var.location
  resource_group_name   = var.resource_group_name
}

resource "azurerm_subnet" "subnet_jenkins" {
  name                 = "proj-subnet"
  resource_group_name   = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "lb_public_ip" {
  name                = "lb-public-ip"
  location              = var.location
  resource_group_name   = var.resource_group_name
  allocation_method  = "Static"
}