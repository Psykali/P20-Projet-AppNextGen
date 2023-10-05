######################
## Create Azure AKS ##
######################
resource "azurerm_kubernetes_cluster" "psykprojs" {
  count               = 2
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
}
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
    metric_name      = "node_cpu_usage_percentage"
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
    metric_name      = "node_memory_working_set_percentage"
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
    metric_name      = "node_network_in_bytes"
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
    metric_name      = "node_network_out_bytes"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  window_size        = "PT15M"
  frequency          = "PT5M"
}