resource "azurerm_virtual_machine" "jenkins_vm" {
  name                = "jenkins-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.jenkins_nic.id]
  size                  = "Standard_B2ms"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  disable_password_authentication = false

  storage_os_disk {
    name              = "jenkins-osdisk"
    caching           = "ReadWrite"
    create_option    = "FromImage"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine" "admin_vm" {
  name                = "admin-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.admin_nic.id]
  size                  = "Standard_B2ms"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  disable_password_authentication = false
  
  storage_os_disk {
    name              = "admin-osdisk"
    caching           = "ReadWrite"
    create_option    = "FromImage"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

