resource "azurerm_network_security_group" "nsg_jenkins" {
  name                = "nsg-jenkins"
  location              = var.location
  resource_group_name   = var.resource_group_name
}

resource "azurerm_network_security_group" "nsg_admin" {
  name                = "nsg-admin"
  location              = var.location
  resource_group_name   = var.resource_group_name
}

resource "azurerm_network_security_rule" "nsg_rule_ssh" {
  name                        = "nsg-rule-ssh"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name   = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_jenkins.name
}

resource "azurerm_network_security_rule" "nsg_rule_http" {
  name                        = "nsg-rule-http"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name   = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_jenkins.name
}

resource "azurerm_network_security_rule" "nsg_rule_https" {
  name                        = "nsg-rule-https"
  priority                    = 1003
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name   = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_jenkins.name
}

resource "azurerm_network_security_rule" "nsg_rule_jenkins" {
  name                        = "nsg-rule-jenkins"
  priority                    = 1004
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name   = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_jenkins.name
}

resource "azurerm_network_security_rule" "nsg_rule_admin_ssh" {
  name                        = "nsg-rule-admin-ssh"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name   = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_admin.name
}

resource "azurerm_network_security_rule" "nsg_rule_admin_http" {
  name                        = "nsg-rule-admin-http"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name   = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_admin.name
}

resource "azurerm_network_security_rule" "nsg_rule_admin_https" {
  name                        = "nsg-rule-admin-https"
  priority                    = 1003
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name   = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_admin.name
}

resource "azurerm_network_security_rule" "nsg_rule_ansible" {
  name                        = "nsg-rule-ansible"
  priority                    = 1004
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name   = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_admin.name
}