
resource "azurerm_lb" "lb" {
  name                = "my-lb"
  location              = var.location
  resource_group_name   = var.resource_group_name
  sku                 = "Basic"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "jenkins_backend_pool" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "jenkins-backend-pool"
}

resource "azurerm_lb_backend_address_pool" "admin_backend_pool" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "admin-backend-pool"
}