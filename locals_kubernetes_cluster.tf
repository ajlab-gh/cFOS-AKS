locals {
  kubernetes_clusters = {
    "${var.prefix}-aks-01" = {
      name                = "${var.prefix}-aks-01"
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      dns_prefix          = "${var.prefix}-aks-01"

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
