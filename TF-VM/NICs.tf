resource "azurerm_network_interface" "jenkins_nic" {
  name                = "jenkins-nic"
  location              = var.location
  resource_group_name   = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.proj_subnet.id
    private_ip_address_allocation = "Dynamic"
      
      public_ip_address {
      name                = "jenkins-public-ip"
      location            = var.location
      resource_group_name = var.resource_group_name
      allocation_method   = "Static"
      sku                 = "Basic"

      dns_settings {
        domain_name_label = "jenkins-vm"
      }
  }
}
}

resource "azurerm_network_interface" "admin_nic" {
  name                = "admin-nic"
  location              = var.location
  resource_group_name   = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.proj_subnet.id
    private_ip_address_allocation = "Dynamic"
      
      public_ip_address {
      name                = "admin-public-ip"
      location            = var.location
      resource_group_name = var.resource_group_name
      allocation_method   = "Static"
      sku                 = "Basic"

      dns_settings {
        domain_name_label = "admin-vm"
      }
  }
}
}
