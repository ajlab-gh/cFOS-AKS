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


resource "null_resource" "fetch_nic_ids_and_attach_lb" {
  for_each = toset(var.regions)

  provisioner "local-exec" {
    interpreter = ["/opt/microsoft/powershell/7/pwsh", "-Command"]
    command     = <<EOT

# Define your variables
$resourceGroupName = "${var.prefix}-${each.key}-aks-rg"
$vmssResourceGroupName = "MC_${var.prefix}-${each.key}-aks-rg_${var.prefix}-aks-${each.key}_${each.key}"
$loadBalancerName = "${var.prefix}-${each.key}-elb"
$backendPoolName = "${var.prefix}-${each.key}-bep"

Write-Host "Fetching VMSS names in resource group: $vmssResourceGroupName"
$vmssNames = (Get-AzVmss -ResourceGroupName $vmssResourceGroupName).Name

foreach ($vmssName in $vmssNames) {
    Write-Host "Processing VMSS: $vmssName"

    # Get the Load Balancer
    $lb = Get-AzLoadBalancer -ResourceGroupName $resourceGroupName -Name $loadBalancerName
    Write-Host "Fetched Load Balancer: $loadBalancerName"

    # Get the Backend Pool
    $backendPool = $lb.BackendAddressPools | Where-Object { $_.Name -eq $backendPoolName }
    Write-Host "Fetched Backend Pool: $backendPoolName"

    # Get the VMSS configuration
    $vmss = Get-AzVmss -ResourceGroupName $vmssResourceGroupName -VMScaleSetName $vmssName
    Write-Host "Fetched VMSS configuration for: $vmssName"

    # Create a new SubResource object for the backend pool
    $backendPoolSubResource = [Microsoft.Azure.Management.Compute.Models.SubResource]::new()
    $backendPoolSubResource.Id = $backendPool.Id

    # Ensure LoadBalancerBackendAddressPools is initialized and add the backend pool to each IP configuration
    foreach ($nicConfig in $vmss.VirtualMachineProfile.NetworkProfile.NetworkInterfaceConfigurations) {
        foreach ($ipConfig in $nicConfig.IpConfigurations) {
            if (-not $ipConfig.LoadBalancerBackendAddressPools) {
                $ipConfig.LoadBalancerBackendAddressPools = [System.Collections.Generic.List[Microsoft.Azure.Management.Compute.Models.SubResource]]::new()
            }
            $ipConfig.LoadBalancerBackendAddressPools.Add($backendPoolSubResource)
        }
    }
    Write-Host "Updated IP configurations for VMSS: $vmssName"

    # Update the VMSS
    Update-AzVmss -ResourceGroupName $vmssResourceGroupName -Name $vmssName -VirtualMachineScaleSet $vmss
    Write-Host "Updated VMSS: $vmssName"

    # Ensure VMSS Instances are Updated
    $instanceIds = (Get-AzVmssVM -ResourceGroupName $vmssResourceGroupName -VMScaleSetName $vmssName).InstanceId
    Update-AzVmssInstance -ResourceGroupName $vmssResourceGroupName -VMScaleSetName $vmssName -InstanceId $instanceIds
    Write-Host "Updated instances for VMSS: $vmssName"
}
Write-Host "Completed processing for region: ${each.key}"
EOT
  }
  depends_on = [azurerm_kubernetes_cluster.kubernetes_cluster, azurerm_lb_backend_address_pool.lb_backend_address_pool]
}
