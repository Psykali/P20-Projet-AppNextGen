resource "azurerm_lb_nat_rule" "jenkins_nat_rule" {
  count = 2

  resource_group_name   = var.resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "jenkins-nat-rule-${count.index}"
  protocol            = "Tcp"
  frontend_port       = 8080 + count.index
  backend_port        = 8080
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
  backend_address_pool_id = azurerm_lb_backend_address_pool.jenkins_backend_pool.id
}

resource "azurerm_lb_nat_rule" "admin_nat_rule" {
  count = 2

  resource_group_name   = var.resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "admin-nat-rule-${count.index}"
  protocol            = "Tcp"
  frontend_port       = 8082 + count.index
  backend_port        = 8080
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
  backend_address_pool_id = azurerm_lb_backend_address_pool.admin_backend_pool.id
}
