locals {
  resource_group_name = "${var.prefix}-rg"
  location            = "eastus"
  environment_tag     = "${var.prefix}-cFOS-Demo"

  resource_groups = {
    for region in var.regions :
    "${var.prefix}-${region}-aks-rg" => {
      name     = "${var.prefix}-${region}-aks-rg"
      location = region
      tags     = { Environment = local.environment_tag }
    }
  }
}
