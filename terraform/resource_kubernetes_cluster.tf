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
  for_each            = local.kubernetes_clusters
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = "${var.prefix}-aks-${each.key}"
  #kubernetes_version                = data.azurerm_kubernetes_service_versions.current[each.key].latest_version
  kubernetes_version                = "1.27.9"
  sku_tier                          = "Standard"
  node_resource_group               = "MC-${each.value.name}"
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
    os_disk_type                = "Ephemeral"
    os_disk_size_gb             = "256"
    upgrade_settings {
      max_surge = "10%"
    }
  }
  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
  }

  identity {
    type = each.value.identity.type
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "node-pool" {
  for_each              = local.kubernetes_clusters
  name                  = "gpu"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.kubernetes_cluster[each.key].id
  vm_size               = "Standard_NC24s_v3"
  node_count            = 1
  os_sku                = "AzureLinux"
}

output "kube_config" {
  description = "Virtual Network Name"
  value       = [for cluster in azurerm_kubernetes_cluster.kubernetes_cluster : cluster.kube_config_raw]
  sensitive   = true
}

resource "azurerm_kubernetes_cluster_extension" "flux-extension" {
  for_each          = local.kubernetes_clusters
  depends_on        = [azurerm_kubernetes_cluster_node_pool.node-pool[each.key]]
  name              = "flux-extension"
  cluster_id        = azurerm_kubernetes_cluster.kubernetes_cluster[each.key].id
  extension_type    = "microsoft.flux"
  release_namespace = "flux-system"
  configuration_settings = {
    "image-automation-controller.enabled" = true,
    "image-reflector-controller.enabled"  = true,
    "helm-controller.detectDrift"         = true,
    "notification-controller.enabled"     = true
  }
}

resource "azurerm_kubernetes_flux_configuration" "fos-aks" {
  for_each                          = local.kubernetes_clusters
  name                              = "fos-aks"
  cluster_id                        = azurerm_kubernetes_cluster.kubernetes_cluster[each.key].id
  namespace                         = "cluster-config"
  scope                             = "cluster"
  continuous_reconciliation_enabled = true
  git_repository {
    url                      = "https://github.com/AJLab-GH/cFOS-AKS"
    reference_type           = "branch"
    reference_value          = "dev"
    sync_interval_in_seconds = 60
  }
  kustomizations {
    name                       = "manifests"
    recreating_enabled         = true
    garbage_collection_enabled = true
    path                       = "./manifests"
    sync_interval_in_seconds   = 60
  }
  depends_on = [
    azurerm_kubernetes_cluster_extension.flux-extension
  ]
}
