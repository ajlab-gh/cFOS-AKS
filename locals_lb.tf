locals {

  lbs = {
    for region in var.regions :
    "${var.prefix}-${region}-elb" => {
      resource_group_name = azurerm_resource_group.resource_group["${var.prefix}-${region}-aks-rg"].name
      location            = azurerm_resource_group.resource_group["${var.prefix}-${region}-aks-rg"].location

      name = "${var.prefix}-${region}-elb"
      sku  = "Standard"
      frontend_ip_configurations = [
        {
          name                 = "${var.prefix}-${region}-elb-fe-ip"
          public_ip_address_id = azurerm_public_ip.public_ip["${var.prefix}-${region}-aks-pip"].id
        }
      ]
    }
  }
  public_ips = {
    for region in var.regions :
    "${var.prefix}-${region}-aks-pip" => {
      resource_group_name = azurerm_resource_group.resource_group["${var.prefix}-${region}-aks-rg"].name
      location            = azurerm_resource_group.resource_group["${var.prefix}-${region}-aks-rg"].location

      name              = "${var.prefix}-${region}-aks-pip"
      allocation_method = "Static"
      sku               = "Standard"
    }
  }
  lb_backend_address_pools = {
    for region in var.regions :
    "${var.prefix}-${region}-bep" => {
      name            = "${var.prefix}-${region}-bep"
      loadbalancer_id = azurerm_lb.lb["${var.prefix}-${region}-elb"].id
    }
  }
  lb_probes = {
    for region in var.regions :
    "${var.prefix}-${region}-hp" => {
      name                = "${var.prefix}-${region}-hp"
      loadbalancer_id     = azurerm_lb.lb["${var.prefix}-${region}-elb"].id
      port                = "80"
      interval_in_seconds = 5
    }
  }
  lb_rules = {
    for region in var.regions :
    "${var.prefix}-${region}-lbr-tcp_80" => {
      name                           = "${var.prefix}-${region}-lbr-tcp_80"
      loadbalancer_id                = azurerm_lb.lb["${var.prefix}-${region}-elb"].id
      frontend_ip_configuration_name = "${var.prefix}-${region}-elb-fe-ip"
      protocol                       = "Tcp"
      frontend_port                  = "80"
      backend_port                   = "80"
      backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_backend_address_pool["${var.prefix}-${region}-bep"].id]
      probe_id                       = azurerm_lb_probe.lb_probe["${var.prefix}-${region}-hp"].id
      disable_outbound_snat          = true
    }
  }
}
