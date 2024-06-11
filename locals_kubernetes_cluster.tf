locals {
  kubernetes_clusters = {
    (local.kubernetes_cluster_name_01) = {
      name                = local.kubernetes_cluster_name_01
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      dns_prefix          = local.kubernetes_cluster_name_01

      default_node_pool = {
        name           = "default"
        node_count     = 1
        vm_size        = "Standard_D4_v2"
        vnet_subnet_id = azurerm_subnet.subnet["${var.prefix}-aks-snet"].id
      }

      identity = {
        type = "SystemAssigned"
      }
    }
  }
}
