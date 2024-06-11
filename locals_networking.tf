locals {

  virtual_network_name_01 = "${var.prefix}-vnet"

  virtual_networks = {
    (local.virtual_network_name_01) = {
      name                = local.virtual_network_name_01
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location
      address_space       = ["${var.virtual_network_cidr}"]
    }
  }

  subnets = {
    "${var.prefix}-aks-snet" = {
      name                 = "${var.prefix}-aks-snet"
      resource_group_name  = azurerm_resource_group.resource_group[local.resource_group_name].name
      virtual_network_name = azurerm_virtual_network.virtual_network[local.virtual_network_name_01].name
      address_prefixes     = [cidrsubnet(azurerm_virtual_network.virtual_network[local.virtual_network_name_01].address_space[0], 8, 0)]
    },
    "${var.prefix}-acr-snet" = {
      name                 = "${var.prefix}-acr-snet"
      resource_group_name  = azurerm_resource_group.resource_group[local.resource_group_name].name
      virtual_network_name = azurerm_virtual_network.virtual_network[local.virtual_network_name_01].name
      address_prefixes     = [cidrsubnet(azurerm_virtual_network.virtual_network[local.virtual_network_name_01].address_space[0], 8, 1)]
    }
  }


  network_security_groups = {
    "${var.prefix}-aks-nsg" = {
      name                = "${var.prefix}-aks-nsg"
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

    },
    "${var.prefix}-acr-nsg" = {
      name                = "${var.prefix}-acr-nsg"
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location
    }
  }

  network_security_rules = {
    "${var.prefix}-aks-nsg-ingress" = {
      resource_group_name         = azurerm_resource_group.resource_group[local.resource_group_name].name
      name                        = "${var.prefix}-aks-nsg-ingress"
      network_security_group_name = azurerm_network_security_group.network_security_group["${var.prefix}-aks-nsg"].name
      priority                    = 1000
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_ranges     = ["80", "443", "11443"]
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
    },
    "${var.prefix}-aks-nsg-egress" = {
      resource_group_name         = azurerm_resource_group.resource_group[local.resource_group_name].name
      name                        = "${var.prefix}-aks-nsg-egress"
      network_security_group_name = azurerm_network_security_group.network_security_group["${var.prefix}-aks-nsg"].name
      priority                    = 1000
      direction                   = "Outbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_ranges     = ["80", "443"]
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
    },
    "${var.prefix}-acr-nsg-ingress" = {
      resource_group_name         = azurerm_resource_group.resource_group[local.resource_group_name].name
      name                        = "${var.prefix}-acr-nsg-ingress"
      network_security_group_name = azurerm_network_security_group.network_security_group["${var.prefix}-acr-nsg"].name
      priority                    = 1000
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_ranges     = ["80", "443"]
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
    },
    "${var.prefix}-acr-nsg-egress" = {
      resource_group_name         = azurerm_resource_group.resource_group[local.resource_group_name].name
      name                        = "${var.prefix}-acr-nsg-egress"
      network_security_group_name = azurerm_network_security_group.network_security_group["${var.prefix}-acr-nsg"].name
      priority                    = 1000
      direction                   = "Outbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_ranges     = ["80", "443"]
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
    }
  }

  subnet_network_security_group_associations = {
    "${var.prefix}-aks-snet-association" = {
      subnet_id                 = azurerm_subnet.subnet["${var.prefix}-aks-snet"].id
      network_security_group_id = azurerm_network_security_group.network_security_group["${var.prefix}-aks-nsg"].id
    },
    "${var.prefix}-acr-snet-association" = {
      subnet_id                 = azurerm_subnet.subnet["${var.prefix}-acr-snet"].id
      network_security_group_id = azurerm_network_security_group.network_security_group["${var.prefix}-acr-nsg"].id
    }
  }
}
