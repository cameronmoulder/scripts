variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
  default     = "my-resource-group"
}

variable "location" {
  type        = string
  description = "Azure location for the resources"
  default     = "East US"
}

variable "vnet_name" {
  type        = string
  description = "The name of the virtual network"
  default     = "my-vnet"
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network"
  default     = ["10.0.0.0/16"]
}
