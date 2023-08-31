resource "azurerm_network_security_group" "proj_nsg" {
  name                = "proj-nsg"
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
  network_security_group_name = azurerm_network_security_group.proj_nsg.name
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
  network_security_group_name = azurerm_network_security_group.proj_nsg.name
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
  network_security_group_name = azurerm_network_security_group.proj_nsg.name
}

resource "azurerm_network_security_rule" "nsg_rule_custom" {
  name                        = "nsg-rule-8080"
  priority                    = 1004
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name   = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.proj_nsg.name
}