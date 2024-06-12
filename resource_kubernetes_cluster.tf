data "azurerm_kubernetes_service_versions" "current" {
  for_each        = local.kubernetes_clusters
  location        = each.value.location
  include_preview = false
}

resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  for_each                          = local.kubernetes_clusters
  name                              = each.value.name
  location                          = each.value.location
  resource_group_name               = each.value.resource_group_name
  dns_prefix                        = "${var.prefix}-aks-${each.key}"
  kubernetes_version                = data.azurerm_kubernetes_service_versions.current[each.key].latest_version
  sku_tier                          = "Standard"
  role_based_access_control_enabled = true

  default_node_pool {
    temporary_name_for_rotation = "rotation"
    name                        = each.value.default_node_pool.name
    node_count                  = each.value.default_node_pool.node_count
    vm_size                     = each.value.default_node_pool.vm_size
    vnet_subnet_id              = lookup(local.aks_subnet_ids, "${var.prefix}-${split("-", each.key)[2]}-aks-subnet")
  }
  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
  }

  identity {
    type = each.value.identity.type
  }
  depends_on = [azurerm_subnet.aks_subnet]
}


#output "kubernetes_clusters" {
#  value = var.enable_output ? azurerm_kubernetes_cluster.kubernetes_cluster[*] : null
#}

#output "kube_config" {
#  value     = azurerm_kubernetes_cluster.kubernetes_cluster[*].kube_config_raw
#  sensitive = true
#}

resource "azurerm_kubernetes_cluster_extension" "flux-extension" {
  for_each       = local.kubernetes_clusters
  name           = "flux-extension"
  cluster_id     = azurerm_kubernetes_cluster.kubernetes_cluster[each.key].id
  extension_type = "microsoft.flux"
}

resource "azurerm_kubernetes_flux_configuration" "example" {
  for_each   = local.kubernetes_clusters
  name       = "example-fc"
  cluster_id = azurerm_kubernetes_cluster.kubernetes_cluster[each.key].id
  namespace  = "flux"

  git_repository {
    url             = "https://github.com/AJLab-GH/microservices-demo"
    reference_type  = "branch"
    reference_value = "main"
  }

  kustomizations {
    name = "kustomization-1"
  }

  depends_on = [
    azurerm_kubernetes_cluster_extension.flux-extension
  ]
}
