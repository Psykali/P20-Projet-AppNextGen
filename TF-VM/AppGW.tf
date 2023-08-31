resource "azurerm_application_gateway" "example" {
  name                = "sk-appgateway"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "skgw-ip"
    subnet_id = azurerm_subnet.proj_subnet.id
  }

  frontend_port {
    name = "port_80"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "my-frontend-ip-configuration"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }

  backend_address_pool {
    name         = "jenkins-backend-pool"
    ip_addresses = [azurerm_network_interface.jenkins_nic.private_ip_address]
  }

  backend_address_pool {
    name         = "admin-backend-pool"
    ip_addresses = [azurerm_network_interface.admin_nic.private_ip_address]
  }

  backend_http_settings {
    name                  = "my-backend-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "my-http-listener"
    frontend_ip_configuration_name = "my-frontend-ip-configuration"
    frontend_port_name             = "port_80"
    protocol                       = "Http"
  }

  request_routing_rule {
    name               = "jenkins-rule"
    rule_type          = "Basic"
    http_listener_name = "my-http-listener"
    backend_address_pool_name      = "jenkins-backend-pool"
    backend_http_settings_name     = "my-backend-http-settings"

    hostnames = ["skproj-jenkins-vm.francecentral.cloudapp.azure.com"]
  }

  request_routing_rule {
    name               = "admin-rule"
    rule_type          = "Basic"
    http_listener_name = "my-http-listener"
    backend_address_pool_name      = "admin-backend-pool"
    backend_http_settings_name     = "my-backend-http-settings"

    hostnames = ["skproj-admin-vm.francecentral.cloudapp.azure.com"]
  }
}
