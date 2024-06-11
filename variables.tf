variable "prefix" {
  description = "Define the Prefix to be used in this Deployment"
}
variable "virtual_network_cidr" {
  description = "CIDR Notation for Virtual Network"
  type        = string
  default     = "10.20.0.0/16"
}
variable "enable_output" {
  description = "Enable/Disable output"
  default     = false
}
variable "manifest_url" {
  description = "URL to the Kubernetes manifest file"
  type        = string
  default     = "https://raw.githubusercontent.com/AJLab-GH/microservices-demo/main/release/kubernetes-manifests.yaml"
}
variable "regions" {
  description = "List of regions"
  type        = list(string)
  default     = ["canadacentral", "canadaeast"]
}
