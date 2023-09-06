####################
## Create AdminVM ##
####################
resource "azurerm_linux_virtual_machine" "admin_vm" {
  name                = "admin-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.admin_nic.id]
  size                  = "Standard_B2ms"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  disable_password_authentication = false
  os_disk {
    name                 = "admin-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
####################
## Bash Scripting ##
####################
resource "null_resource" "install_packages_ansible" {
  depends_on = [
    azurerm_linux_virtual_machine.admin_vm,
  ]
  
  connection {
    type     = "ssh"
    user     = var.admin_username
    password = var.admin_password
    host     = azurerm_linux_virtual_machine.admin_vm.public_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update && sudo apt-get -y upgrade",
      "sudo apt-get install -y apache2 ca-certificates curl gnupg",
      "sudo apt-get install -y mariadb-server",
      "sudo apt-get install -y php libapache2-mod-php php-mysql",
#      "sudo apt-add-repository ppa:ansible/ansible",
#      "sudo apt update",
#      "sudo apt install -y ansible",
#      "sudo install -m 0755 -d /etc/apt/keyrings",
#      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
#      "sudo chmod a+r /etc/apt/keyrings/docker.gpg",
#      "echo 'deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \"$(. /etc/os-release && echo \"$VERSION_CODENAME\")\" stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
#      "sudo apt update",
#      "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y",
    ]
    ## https://docs.docker.com/engine/install/ubuntu/
    ## https://hub.docker.com/u/psykali
  }

}