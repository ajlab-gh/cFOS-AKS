resource "azurerm_resource_group" "resource_group" {
  for_each = local.resource_groups
  name     = each.value.name
  location = each.value.location
  tags     = each.value.tags
}

output "resource_groups" {
  value = var.enable_output ? azurerm_resource_group.resource_group[*] : null
}
