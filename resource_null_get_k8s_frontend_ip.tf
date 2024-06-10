resource "null_resource" "get_frontend_ip" {
  provisioner "local-exec" {
    command = <<EOT
    sleep 60  # Wait for the load balancer to provision the IP
    kubectl get svc frontend-external -o jsonpath='{.status.loadBalancer.ingress[0].ip}' > frontend_ip.txt
    sleep 5  # Ensure the file has been written
    EOT

    interpreter = ["bash", "-c"]
    when        = create
  }

  triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = [null_resource.k8s_apply, azurerm_kubernetes_cluster.kubernetes_cluster]
}

data "local_file" "frontend_ip" {
  filename = "frontend_ip.txt"
  depends_on = [null_resource.get_frontend_ip]
}

output "frontend_service_ip" {
  value = data.local_file.frontend_ip.content
}