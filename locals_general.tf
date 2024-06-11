locals {
  resource_group_name = "${var.prefix}-rg"
  location            = "canadacentral"
  environment_tag     = "${var.prefix}-cFOS-Demo"

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
