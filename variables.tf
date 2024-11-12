variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
}

variable "address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "The address prefixes for the subnets."
  type        = map(string)
}

# Optional Bastion variables
variable "bastion" {
  description = "Configuration for the Azure Bastion Host"
  type = object({
    name                    = optional(string, "bastion-host")
    public_ip_name          = optional(string, "bastion-pip")
    copy_paste_enabled      = optional(bool, true)
    file_copy_enabled       = optional(bool, true)
    scale_units             = optional(number, 2)
    idle_timeout_in_minutes = optional(number, 4)
    tags                    = optional(map(string), {})

    # Additional optional attributes
    zones                   = optional(list(string), [])
    domain_name_label       = optional(string, null)
  })
}