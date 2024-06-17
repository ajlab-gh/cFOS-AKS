data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

data "azurerm_kubernetes_service_versions" "current" {
  for_each        = local.kubernetes_clusters
  location        = each.value.location
  include_preview = false
}

resource "azurerm_log_analytics_workspace" "log-analytics" {
  for_each            = local.kubernetes_clusters
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = "PerGB2018"
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
  oidc_issuer_enabled               = true
  workload_identity_enabled         = true
  api_server_access_profile {
    authorized_ip_ranges = [
      "${chomp(data.http.myip.response_body)}/32"
    ]
  }
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.log-analytics[each.key].id
  }
  default_node_pool {
    temporary_name_for_rotation = "rotation"
    name                        = each.value.default_node_pool.name
    node_count                  = each.value.default_node_pool.node_count
    vm_size                     = each.value.default_node_pool.vm_size
    vnet_subnet_id              = each.value.default_node_pool.vnet_subnet_id
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

output "kube_config" {
  description = "Virtual Network Name"
  value       = [for cluster in azurerm_kubernetes_cluster.kubernetes_cluster : cluster.kube_config_raw]
  sensitive   = true
}

resource "azurerm_kubernetes_cluster_extension" "flux-extension" {
  for_each       = local.kubernetes_clusters
  name           = "flux-extension"
  cluster_id     = azurerm_kubernetes_cluster.kubernetes_cluster[each.key].id
  extension_type = "microsoft.flux"
}

resource "azurerm_kubernetes_flux_configuration" "store" {
  for_each   = local.kubernetes_clusters
  name       = "store"
  cluster_id = azurerm_kubernetes_cluster.kubernetes_cluster[each.key].id
  namespace  = "flux-system"
  scope      = "cluster"
  git_repository {
    url             = "https://github.com/robinmordasiewicz/aks-store-demo-manifests"
    reference_type  = "branch"
    reference_value = "main"
  }
  kustomizations {
    name                       = "dev"
    recreating_enabled         = true
    garbage_collection_enabled = true
    path                       = "./overlays/dev"
  }
  depends_on = [
    azurerm_kubernetes_cluster_extension.flux-extension
  ]
}
