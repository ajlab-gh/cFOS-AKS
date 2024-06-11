locals {
  resource_group_name        = "${var.prefix}-rg"
  location                   = "canadacentral"
  environment_tag            = "${var.prefix}-cFOS-Demo"
  kubernetes_cluster_name_01 = "${var.prefix}-aks-01"
  registry_cleaned_string    = replace(local.kubernetes_cluster_name_01, "-", "")

  resource_groups = {
    for region in var.regions :
    "${var.prefix}-${region}-aks-rg" => {
      name     = "${var.prefix}-${region}-aks-rg"
      location = region
      tags     = { Environment = local.environment_tag }
    }
  }
}
