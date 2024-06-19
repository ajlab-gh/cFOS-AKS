resource "null_resource" "cfos_image" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = <<EOF
        docker import - cfos < FOS_X64_DOCKER-v7-build0255-FORTINET.tar || true
    EOF
  }
}

data "azurerm_container_registry" "container_registry" {
  for_each            = local.container_registrys
  depends_on          = [azurerm_container_registry.container_registry]
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

resource "null_resource" "cfos_image-push" {
  for_each   = local.container_registrys
  depends_on = [null_resource.cfos_image, data.azurerm_container_registry.container_registry]
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = <<EOF
      docker tag cfos ${each.value.name}.azurecr.io/cfos:latest
      echo "${data.azurerm_container_registry.container_registry[each.key].admin_password}" | docker login --username ${data.azurerm_container_registry.container_registry[each.key].admin_username} --password-stdin ${each.value.name}.azurecr.io
      docker push ${each.value.name}.azurecr.io/cfos:latest
    EOF
  }
}
