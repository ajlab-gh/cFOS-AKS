locals {
  resource_group_name = "${var.prefix}-rg"
  location            = "canadacentral"
  environment_tag     = "${var.prefix}-cFOS-Demo"
  kubernetes_cluster_name_01 = "${var.prefix}-aks-01"
  registry_cleaned_string = replace(local.kubernetes_cluster_name_01, "-", "")

  resource_groups = {
    (local.resource_group_name) = {
      name     = local.resource_group_name
      location = local.location
      tags = {
        Environment = local.environment_tag
      }
    }
  }
}
