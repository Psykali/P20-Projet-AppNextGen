# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "myVNet"
  location              = var.location
  resource_group_name   = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

# Create a subnet for the virtual machines
resource "azurerm_subnet" "subnet_vm" {
  name                 = "mySubnet-vm"
  resource_group_name   = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP address for the Load Balancer
resource "azurerm_public_ip" "pip" {
  name                = "myPublicIP"
  location              = var.location
  resource_group_name   = var.resource_group_name
  allocation_method   = "Dynamic"
}

# Create a Load Balancer
resource "azurerm_lb" "lb" {
  name                = "myLoadBalancer"
  location              = var.location
  resource_group_name   = var.resource_group_name

  frontend_ip_configuration {
    name                 = "myFrontendIPConfig"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

# Create a backend address pool for the Load Balancer
resource "azurerm_lb_backend_address_pool" "pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "myBackendAddressPool"
}

# Create a load balancing rule for SSH traffic
resource "azurerm_lb_rule" "rule_ssh" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "myLoadBalancingRule-SSH"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "myFrontendIPConfig"
}

# Create a network security group for the virtual machines
resource "azurerm_network_security_group" "nsg_vm" {
  name                = "myNetworkSecurityGroup-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 80
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 443
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create the first virtual machine with Jenkins installed on it and FQDN skjenk.
resource "azurerm_linux_virtual_machine" "vm1" {
  name                  = var.first_vm
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = "Standard_DS1_v2"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic_vm1.id]

  os_disk {
    caching             = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  custom_data = base64encode(file("cloud-init.yaml"))
}

resource "azurerm_network_interface_security_group_association" "nic_sg_vm1"{
    network_interface_id      =azurerm_network_interface.nic_vm1.id
    network_security_group_id =azurerm_network_security_group.nsg_vm.id
}
resource "azurerm_network_interface_backend_address_pool_association" "nic_pool_vm1"{
    network_interface_id      =azurerm_network_interface.nic_vm1.id
    ip_configuration_name     ="internal"
    backend_address_pool_id   =azurerm_lb_backend_address_pool.pool.id
}
resource "azurerm_public_ip" "pip_vm1"{
  name                  ="${var.first_vm}-PIP"
  location              = var.location
  resource_group_name   = var.resource_group_name
  allocation_method     ="Dynamic"
}
resource "azurerm_network_interface" "nic_vm1"{
  name                  ="${var.first_vm}-NIC"
  location              = var.location
  resource_group_name   = var.resource_group_name
  ip_configuration{
  name="internal"
  subnet_id=azurerm_subnet.subnet_vm.id
  private_ip_address_allocation="Dynamic"
  public_ip_address_id=azurerm_public_ip.pip_vm2.id
  }
}

# Create the second virtual machine with Ansible and Docker installed on it and FQDN skans.
resource "azurerm_linux_virtual_machine" "vm2" {
  name                  = var.second_vm
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = "Standard_DS1_v2"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids=[azurerm_network_interface.nic_vm2.id]
  os_disk {
    caching             = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  custom_data = base64encode(file("cloud-init.yaml"))
}

resource "azurerm_network_interface_security_group_association" "nic_sg_vm2"{
  network_interface_id=azurerm_network_interface.nic_vm2.id
  network_security_group_id=azurerm_network_security_group.nsg_vm.id
}
resource "azurerm_network_interface_backend_address_pool_association" "nic_pool_vm2"{
  network_interface_id=azurerm_network_interface.nic_vm2.id
  ip_configuration_name="internal"
  backend_address_pool_id=azurerm_lb_backend_address_pool.pool.id
}
resource "azurerm_public_ip" "pip_vm2"{
  name                  ="${var.second_vm}-PIP"
  location              = var.location
  resource_group_name   = var.resource_group_name
  allocation_method     ="Dynamic"
}
resource "azurerm_network_interface" "nic_vm2"{
  name                  ="${var.second_vm}-NIC"
  location              = var.location
  resource_group_name   = var.resource_group_name
  ip_configuration{
  name="internal"
  subnet_id=azurerm_subnet.subnet_vm.id
  private_ip_address_allocation="Dynamic"
  public_ip_address_id=azurerm_public_ip.pip_vm2.id
  }
}
####################
## Bash Scripting ##
####################
resource "null_resource" "install_packages_jenkins" {
  depends_on = [
    azurerm_linux_virtual_machine.vm1,
  ]
  connection {
    type     = "ssh"
    user     = var.admin_username
    password = var.admin_password
    host     = azurerm_linux_virtual_machine.vm1.public_ip_address
  }

provisioner "remote-exec" {
  inline = [
        "sudo apt-get update && sudo apt-get -y upgrade",
        "sudo apt-get install -y ansible",
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
resource "null_resource" "install_packages_ansible" {
  depends_on = [
    azurerm_linux_virtual_machine.vm2,
  ]
  connection {
    type     = "ssh"
    user     = var.admin_username
    password = var.admin_password
    host     = azurerm_linux_virtual_machine.vm2.public_ip_address
  }

provisioner "remote-exec" {
  inline = [
        "sudo apt-get update && sudo apt-get -y upgrade",
        "sudo apt-get install -y ansible",
        "sudo apt-get install -y apache2",
        "sudo apt-get install -y mariadb-server",
        "sudo apt-get install -y php libapache2-mod-php php-mysql",
        "sudo apt -y install docker.io"
  ]
  }
}
