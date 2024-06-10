resource "null_resource" "k8s_apply" {
  provisioner "local-exec" {
    command = <<EOT
    # Remove existing kubeconfig entries
    kubectl config delete-context ${var.prefix}-aks-01 || true
    kubectl config delete-cluster ${var.prefix}-aks-01 || true
    kubectl config unset users.clusterUser_${local.resource_group_name}_${var.prefix}-aks-01 || true

    # Get new credentials
    az aks get-credentials --resource-group ${azurerm_resource_group.resource_group["${local.resource_group_name}"].name} --name ${azurerm_kubernetes_cluster.kubernetes_cluster["${var.prefix}-aks-01"].name} --overwrite-existing

    # Apply Kubernetes manifests
    kubectl apply -f ${local_file.microservices_demo.filename} --validate=false
    EOT
  }

  depends_on = [azurerm_kubernetes_cluster.kubernetes_cluster]
}