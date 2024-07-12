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
