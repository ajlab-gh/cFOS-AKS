resource "azurerm_subnet" "aks_subnet" {
  for_each             = local.aks_subnets
  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes
  depends_on           = [azurerm_virtual_network.virtual_network]
}

resource "azurerm_subnet" "acr_subnet" {
  for_each             = local.acr_subnets
  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes
  depends_on           = [azurerm_virtual_network.virtual_network]
}
