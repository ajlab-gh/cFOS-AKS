resource "azurerm_container_registry" "container_registry" {
  for_each                      = local.container_registrys
  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
  sku                           = each.value.sku
  admin_enabled                 = each.value.admin_enabled
  public_network_access_enabled = each.value.public_network_access_enabled
  anonymous_pull_enabled        = each.value.anonymous_pull_enabled
}
