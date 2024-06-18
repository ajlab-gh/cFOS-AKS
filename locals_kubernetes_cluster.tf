locals {
  kubernetes_clusters = {
    for region in var.regions :
    "${var.prefix}-aks-${region}" => {
      name                = "${var.prefix}-aks-${region}"
      location            = azurerm_resource_group.resource_group["${var.prefix}-${region}-aks-rg"].location
      resource_group_name = azurerm_resource_group.resource_group["${var.prefix}-${region}-aks-rg"].name
      dns_prefix          = "${var.prefix}-aks-${region}"

      default_node_pool = {
        name       = "default"
        node_count = 3
        vm_size    = "Standard_F16s_v2"
      }

      identity = {
        type = "SystemAssigned"
      }
    }
  }

  container_registrys = {
    for region in var.regions :
    "${var.prefix}-${region}-acr" => {
      name                          = replace("${var.prefix}${region}acr", "-", "")
      location                      = local.resource_groups["${var.prefix}-${region}-aks-rg"].location
      resource_group_name           = local.resource_groups["${var.prefix}-${region}-aks-rg"].name
      sku                           = "Premium"
      admin_enabled                 = true
      public_network_access_enabled = true
      anonymous_pull_enabled        = false
    }
  }

  role_assignments = {
    for region in var.regions :
    "${var.prefix}-${region}-ra" => {
      principal_id                     = azurerm_kubernetes_cluster.kubernetes_cluster["${var.prefix}-aks-${region}"].kubelet_identity[0].object_id
      role_definition_name             = "AcrPull"
      scope                            = azurerm_container_registry.container_registry["${var.prefix}-${region}-acr"].id
      skip_service_principal_aad_check = true
    }
  }
}
