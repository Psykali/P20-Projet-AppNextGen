######################
## Create Azure AKS ##
######################
resource "azurerm_kubernetes_cluster" "psykprojs" {
  name                = var.kubernetes_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name            = var.node_pool_name
    node_count      = 3
    vm_size         = "Standard_DS2_v2"
    os_disk_size_gb = 30
  }

  identity {
    type = "SystemAssigned"
  }

#  depends_on = [
#    azurerm_subnet.aks,
#  ]
}
#######################
## Define Name space ##
#######################
#resource "azurerm_kubernetes_namespace" "psykprojs" {
#  name                = var.namespace_name
#  depends_on          = [azurerm_kubernetes_cluster.psykprojs]
#  kubernetes_cluster_id = azurerm_kubernetes_cluster.psykprojs.id
#}
#############
## Metrics ##
#############
## CPU
resource "azurerm_monitor_metric_alert" "metrics_cpu" {
  name                      = "skCluster_CPU"
  resource_group_name = var.resource_group_name
  description               = "Alert triggered when CPU usage exceeds threshold"
  severity                  = 3
  enabled                   = true
  scopes                    = [azurerm_kubernetes_cluster.psykprojs.id]
criteria {
    metric_namespace = "microsoft.containerservice/managedclusters"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  window_size        = "PT15M"
  frequency          = "PT5M"
}
## Memory
resource "azurerm_monitor_metric_alert" "metrics_memory" {
  name                      = "skCluster_Memory"
  resource_group_name = var.resource_group_name
  description               = "Alert triggered when memory working set percentage exceeds threshold"
  severity                  = 3
  enabled                   = true
  scopes                    = [azurerm_kubernetes_cluster.psykprojs.id]
criteria {
    metric_namespace = "microsoft.containerservice/managedclusters"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  window_size        = "PT15M"
  frequency          = "PT5M"
}
## NetworkIn
resource "azurerm_monitor_metric_alert" "metrics_networkin" {
  name                      = "skCluster_NetworkIN"
  resource_group_name = var.resource_group_name
  description               = "Alert triggered when network bytes in exceeds threshold"
  severity                  = 3
  enabled                   = true
  scopes                    = [azurerm_kubernetes_cluster.psykprojs.id]
criteria {
    metric_namespace = "microsoft.containerservice/managedclusters"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  window_size        = "PT15M"
  frequency          = "PT5M"
}
## NetworkOut
resource "azurerm_monitor_metric_alert" "metrics_networkout" {
  name                      = "skCluster_NetworkOut"
  resource_group_name = var.resource_group_name
  description               = "Alert triggered when network bytes out exceeds threshold"
  severity                  = 3
  enabled                   = true
  scopes                    = [azurerm_kubernetes_cluster.psykprojs.id]
criteria {
    metric_namespace = "microsoft.containerservice/managedclusters"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  window_size        = "PT15M"
  frequency          = "PT5M"
}