##########################
## Create PubIP Jenkins ##
##########################
resource "azurerm_public_ip" "jenkins_public_ip" {
  name                = "jenkins-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Basic"

  domain_name_label = "jenkins-vm"
}
########################
## Create NIC Jenkins ##
########################
resource "azurerm_network_interface" "jenkins_nic" {
  name                = "jenkins-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.proj_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jenkins_public_ip.id
  }
}
##########################
## Create PubIP AdminVM ##
##########################
resource "azurerm_public_ip" "admin_public_ip" {
  name                = "admin-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Basic"

  domain_name_label = "admin-vm"
}
########################
## Create NIC AdminVM ##
########################
resource "azurerm_network_interface" "admin_nic" {
  name                = "admin-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.proj_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.admin_public_ip.id
  }
}