variable "prefix" {
  description = "Define the Prefix to be used in this Deployment"
}
variable "virtual_network_cidr" {
  description = "CIDR Notation for Virtual Network"
  default     = "10.20.0.0/16"
}
variable "enable_output" {
  description = "Enable/Disable output"
  default     = false
}
