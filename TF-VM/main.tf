###
resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}
###
resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}
###
resource "azurerm_public_ip" "jenkins" {
  name                = "jenkins-publicip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method  = "Static"
}
###
resource "azurerm_public_ip" "ansible" {
  name                = "ansible-publicip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method  = "Static"
}
######
resource "azurerm_lb" "example" {
  name                = "example-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  
  frontend_ip_configuration {
    name                 = "JenkinsIPAddress"
    public_ip_address_id = azurerm_public_ip.jenkins.id
  }

  frontend_ip_configuration {
    name                 = "AnsibleIPAddress"
    public_ip_address_id = azurerm_public_ip.ansible.id
  }
}

resource "azurerm_lb_backend_address_pool" "jenkins" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.example.id
  name                = "jenkins-lb-backend-pool"
}

resource "azurerm_lb_backend_address_pool" "ansible" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.example.id
  name                = "ansible-lb-backend-pool"
}

resource "azurerm_lb_rule" "jenkins" {
  resource_group_name = var.resource_group_name
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "jenkins-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "JenkinsIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.jenkins.id
}

resource "azurerm_lb_rule" "ansible" {
  resource_group_name = var.resource_group_name
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "ansible-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "AnsibleIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.ansible.id
}
#########
resource "azurerm_network_interface" "jenkins" {
  name                = "jenkins-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "jenkins-nic-config"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.jenkins.id]
  }
}

resource "azurerm_network_interface" "ansible" {
  name                = "ansible-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ansible-nic-config"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.ansible.id]
  }
}
####################
resource "azurerm_virtual_machine" "jenkins" {
  name                = var.first_vm
  location            = var.location
  resource_group_name = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.jenkins.id]

  vm_size = "Standard_B1s"

  storage_os_disk {
    name              = "jenkins-osdisk"
    caching           = "ReadWrite"
    create_option    = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "skjenk"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update && sudo apt-get -y upgrade", 
      "sudo apt update && sudo apt -y upgrade",
      "sudo apt-get install -y apache2 wget",
      "sudo apt-get install -y mariadb-server",
      "sudo apt-get install -y php libapache2-mod-php php-mysql",
      "sudo apt-get install -y default-jre",
      "sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -",
      "sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
      "sudo apt-get update",
      "sudo apt-get install -y jenkins"
    ]
  }
}

resource "azurerm_virtual_machine" "ansible" {
  name                = var.second_vm
  location            = var.location
  resource_group_name = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.ansible.id]

  vm_size = "Standard_B1s"

  storage_os_disk {
    name              = "ansible-osdisk"
    caching           = "ReadWrite"
    create_option    = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "skansbile"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update && sudo apt-get -y upgrade", 
      "sudo apt update && sudo apt -y upgrade",
      "sudo apt-get install -y apache2",
      "sudo apt-get install -y mariadb-server",
      "sudo apt-get install -y php libapache2-mod-php php-mysql",
      "sudo apt-get install -y ansible",
      "sudo apt-get install -y curl",
      "sudo apt -y install docker.io"
    ]
  }
}

output "jenkins_ip" {
  value = azurerm_network_interface.jenkins.private_ip_address
}

output "ansible_ip" {
  value = azurerm_network_interface.ansible.private_ip_address
}
