resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  for_each            = local.kubernetes_clusters
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = each.value.dns_prefix

  default_node_pool {
    name       = each.value.default_node_pool.name
    node_count = each.value.default_node_pool.node_count
    vm_size    = each.value.default_node_pool.vm_size
  }

  identity {
    type = each.value.identity.type
  }
}

output "kubernetes_clusters" {
  value = var.enable_output ? azurerm_kubernetes_cluster.kubernetes_cluster[*] : null
}
