locals {
  kubernetes_clusters = {
    for region in var.regions :
    "${var.prefix}-aks-${region}" => {
      name                = "${var.prefix}-aks-${region}"
      location            = azurerm_resource_group.resource_group["${var.prefix}-${region}-aks-rg"].location
      resource_group_name = azurerm_resource_group.resource_group["${var.prefix}-${region}-aks-rg"].name
      dns_prefix          = "${var.prefix}-aks-${region}"

      default_node_pool = {
        name           = "default"
        node_count     = 1
        vm_size        = "Standard_F16s_v2"
        vnet_subnet_id = azurerm_subnet.aks_subnet["${var.prefix}-${region}-aks-subnet"].id
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
}
