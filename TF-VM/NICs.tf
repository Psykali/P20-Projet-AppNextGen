resource "azurerm_network_interface" "jenkins_nic" {
  name                = "jenkins-nic"
  location              = var.location
  resource_group_name   = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.proj_subnet.id
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_network_interface" "admin_nic" {
  name                = "admin-nic"
  location              = var.location
  resource_group_name   = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.proj_subnet.id
    private_ip_address_allocation = "Static"
  }
}

