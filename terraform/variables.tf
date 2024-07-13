variable "prefix" {
  description = "Define the Prefix to be used in this Deployment, This CANNOT include a Hyphen (-)"
}
variable "manifest_url" {
  description = "URL to the Kubernetes manifest file"
  type        = string
  default     = "https://github.com/AJLab-GH/cFOS-AKS"
}
variable "regions" {
  description = "List of regions"
  type        = list(string)
  default     = ["canadacentral"]
}
variable "user_node_pool_node_taints" {
  description = "(Optional) A map of Kubernetes labels which should be applied to nodes in this Node Pool. Changing this forces a new resource to be created."
  type        = list(string)
  default     = ["kubernetes.azure.com/scalesetpriority=spot:NoSchedule"]
}
variable "user_node_pool_node_labels" {
  description = "(Optional) A list of Kubernetes taints which should be applied to nodes in the agent pool (e.g key=value:NoSchedule). Changing this forces a new resource to be created."
  type        = map(any)
  default     = { "kubernetes.azure.com/scalesetpriority" = "spot" }
}
