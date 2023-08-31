resource "azurerm_lb_nat_rule" "jenkins_nat_rule" {
  count                 = length(azurerm_linux_virtual_machine.jenkins_vm)
  resource_group_name   = var.resource_group_name
  loadbalancer_id       = azurerm_lb.lb.id
  protocol              = "Tcp"
  frontend_port         = 80
  backend_port          = 8080
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
}

resource "azurerm_lb_nat_rule" "admin_nat_rule" {
  count                 = length(azurerm_linux_virtual_machine.admin_vm)
  resource_group_name   = var.resource_group_name
  loadbalancer_id       = azurerm_lb.lb.id
  protocol              = "Tcp"
  frontend_port         = 80
  backend_port          = 8080
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
}
