resource "azurerm_container_registry" "container-registry" {
  for_each                      = local.kubernetes_clusters
  name                          = local.registry_cleaned_string
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
  sku                           = "Premium"
  admin_enabled                 = true
  public_network_access_enabled = false
  anonymous_pull_enabled        = false
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
