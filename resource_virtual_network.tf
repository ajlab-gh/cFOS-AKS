resource "azurerm_virtual_network" "virtual_network" {
  for_each            = local.virtual_networks
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
}

output "virtual_networks" {
  value = var.enable_output ? azurerm_virtual_network.virtual_network[*] : null
}
