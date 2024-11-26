variable "location" {
  type        = string
  description = "The location of the Azure Bastion Host."
  nullable    = false
  default = "westeurope"
}

variable "tags" {
  type        = map(string)
  default     = {
    "Resource Type" = "Deployment Automation"
  }
  description = "Tags of the resource."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the Azure Bastion resources are located."
  default = "somerandomname"
}