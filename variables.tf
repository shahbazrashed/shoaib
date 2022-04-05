variable "resourcegroup_name" {
  type        = string
  description = "The name of the resource group"
  default     = "Company-RG"
}

variable "location" {
  type        = string
  description = "The region for the deployment"
  default     = "UK South"
}

variable "tags" {
  type        = map(string)
  description = "Tags used for the deployment"
  default = {
    "Environment" = "Production"
    "Owner"       = "IT"
  }
}

variable "vnet_name" {
  type        = string
  description = "The name of the vnet"
  default     = "Service-Vnet"
}
variable "vnet_address_space" {
  type        = list(any)
  description = "the address space of the VNet"
  default     = ["10.0.0.0/16"]
}

variable "bastionhost_name" {
  type        = string
  description = "The name of the basion host"
  default     = "Company-Bastian-Host"
}

variable "simageid" {
  type = string
  description = "Source image ID"
#default = "/subscriptions/27cxxxxxx-xxxxx-xxxx-axxx-xxxxx6xxxx/resourceGroups/name/providers/Microsoft.Compute/galleries/mycomputegallery/images/Gold-Gallery-Image"
}
## Source image ID can be obtained from the image properties in azure 
