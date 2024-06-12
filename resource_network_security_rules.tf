resource "azurerm_network_security_rule" "nsg_ingress" {
  for_each                    = local.network_security_groups
  name                        = "${each.key}-ingress"
  resource_group_name         = each.value.resource_group_name
  network_security_group_name = each.value.name
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443", "11443"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  depends_on = [azurerm_network_security_group.network_security_group]
}

resource "azurerm_network_security_rule" "nsg_egress" {
  for_each                    = local.network_security_groups
  name                        = "${each.key}-egress"
  resource_group_name         = each.value.resource_group_name
  network_security_group_name = each.value.name
  priority                    = 1001
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  depends_on = [azurerm_network_security_group.network_security_group]
}
