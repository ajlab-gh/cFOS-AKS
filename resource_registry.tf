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

#output "registry_login_server" {
#  value = data.azurerm_container_registry.container-registry.login_server
#}
#output "registry_admin_username" {
#  value = data.azurerm_container_registry.container-registry.admin_username
#}
#output "registry_admin_password" {
#  value = data.azurerm_container_registry.container-registry.admin_password
#}

#data "azurerm_container_registry" "container-registry" {
#  depends_on          = [azurerm_container_registry.container-registry]
#  name                = random_pet.admin_username.id
#  resource_group_name = azurerm_resource_group.azure_resource_group.name
#}
