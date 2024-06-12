locals {

  virtual_networks = {
    for region in var.regions :
    "${var.prefix}-${region}-vnet" => {
      name                = "${var.prefix}-${region}-vnet"
      location            = region
      resource_group_name = local.resource_groups["${var.prefix}-${region}-aks-rg"].name
      address_space       = ["${var.virtual_network_cidr}"]
    }
  }

  aks_subnets = {
    for region in var.regions :
    "${var.prefix}-${region}-aks-subnet" => {
      name                 = "${var.prefix}-${region}-aks-subnet"
      resource_group_name  = local.resource_groups["${var.prefix}-${region}-aks-rg"].name
      virtual_network_name = local.virtual_networks["${var.prefix}-${region}-vnet"].name
      address_prefixes     = [cidrsubnet(var.virtual_network_cidr, 8, 0)]
    }
  }

  aks_subnet_ids = {
    for region in var.regions :
     "${var.prefix}-${region}-aks-subnet" => azurerm_subnet.aks_subnet["${var.prefix}-${region}-aks-subnet"].id
  }

  acr_subnets = {
    for region in var.regions :
    "${var.prefix}-${region}-acr-subnet" => {
      name                 = "${var.prefix}-${region}-acr-subnet"
      resource_group_name  = local.resource_groups["${var.prefix}-${region}-aks-rg"].name
      virtual_network_name = local.virtual_networks["${var.prefix}-${region}-vnet"].name
      address_prefixes     = [cidrsubnet(var.virtual_network_cidr, 8, 1)]
    }
  }

  aks_network_security_groups = {
    for region in var.regions :
    "${var.prefix}-${region}-aks-nsg" => {
      name                = "${var.prefix}-${region}-aks-nsg"
      resource_group_name = local.resource_groups["${var.prefix}-${region}-aks-rg"].name
      location            = local.resource_groups["${var.prefix}-${region}-aks-rg"].location
    }
  }

  acr_network_security_groups = {
    for region in var.regions :
    "${var.prefix}-${region}-acr-nsg" => {
      name                = "${var.prefix}-${region}-acr-nsg"
      resource_group_name = local.resource_groups["${var.prefix}-${region}-aks-rg"].name
      location            = local.resource_groups["${var.prefix}-${region}-aks-rg"].location
    }
  }

  network_security_groups = merge(local.aks_network_security_groups, local.acr_network_security_groups)

  aks_subnet_network_security_group_associations = {
    for region in var.regions :
    "${var.prefix}-${region}-aks-snet-association" => {
      subnet_id                 = azurerm_subnet.aks_subnet["${var.prefix}-${region}-aks-subnet"].id
      network_security_group_id = azurerm_network_security_group.network_security_group["${var.prefix}-${region}-aks-nsg"].id
    }
  }
  acr_subnet_network_security_group_associations = {
    for region in var.regions :
    "${var.prefix}-${region}-acr-snet-association" => {
      subnet_id                 = azurerm_subnet.acr_subnet["${var.prefix}-${region}-acr-subnet"].id
      network_security_group_id = azurerm_network_security_group.network_security_group["${var.prefix}-${region}-acr-nsg"].id
    }
  }

  subnet_network_security_group_associations = merge(local.aks_subnet_network_security_group_associations, local.acr_subnet_network_security_group_associations)

}
