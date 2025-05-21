variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the Azure Bastion resources are located."
}

variable "location" {
  type        = string
  description = "The location of the Azure Bastion Host."
  nullable    = false
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}

variable "public_ip" {
  type = object({
    name                    = optional(string)
    resource_group_name     = optional(string)
    location                = optional(string)
    allocation_method       = optional(string, "Static")
    sku                     = optional(string, "Standard")
    idle_timeout_in_minutes = optional(number)
    tags                    = optional(map(string))
    zones                   = optional(list(string), [])
    domain_name_label       = optional(string)
  })
  default     = {}
  description = "(Optional) The public IP address associated with the Azure Bastion Host."
}

variable "bastion" {
  type = object({
    name                      = string
    subnet_id                 = string
    virtual_network_id        = optional(string, null)
    sku                       = optional(string, "Standard")
    kerberos_enabled          = optional(bool, false)
    scale_units               = optional(number, 2)
    tunneling_enabled         = optional(bool, false)
    shareable_link_enabled    = optional(bool, false)
    session_recording_enabled = optional(bool, false)
    private_only_enabled      = optional(bool, false)
    public_ip_name            = optional(string, null)
    ip_connect_enabled        = optional(bool, false)
    copy_paste_enabled        = optional(bool, false)
    file_copy_enabled         = optional(bool, false)
    idle_timeout_in_minutes   = optional(number, 4)
    tags                      = optional(map(string), {})
    domain_name_label         = optional(string, null)
    zones                     = optional(list(string), [])
  })
  description = <<DESCRIPTION
The Azure Bastion Host configuration.

- `name` - The name of the Azure Bastion Host.
- `location` - The location of the Azure Bastion Host.
- `resource_group_name` - The name of the resource group where the Azure Bastion Host is located.
- `subnet_id` - The ID of the subnet where the Azure Bastion Host will be deployed.
- `virtual_network_id` - The ID of the virtual network where the Azure Bastion Host will be deployed. Default is null. only for Developer SKU.
- `sku` - The SKU of the Azure Bastion Host. Default is 'Standard'. Valid values are 'Basic', 'Standard', 'Developer' or 'Premium'.
- `kerberos_enabled` - Specifies whether Kerberos authentication is enabled for the Azure Bastion Host. Default is false.
- `scale_units` - The number of scale units for the Azure Bastion Host. Default is 2.
- `tunneling_enabled` - Specifies whether tunneling functionality is enabled for the Azure Bastion Host. Default is false.
- `shareable_link_enabled` - Specifies whether shareable link functionality is enabled for the Azure Bastion Host. Default is false.
- `private_only_enabled` - Specifies whether the private only mode is enabled for the Azure Bastion Host. Default is false.
- `session_recording_enabled` - Specifies whether session recording functionality is enabled for the Azure Bastion Host. Default is false.
- `public_ip_name` - The name of the public IP address associated with the Azure Bastion Host. Default is null.
- `ip_connect_enabled` - Specifies whether IP connect functionality is enabled for the Azure Bastion Host. Default is false.
- `copy_paste_enabled` - Specifies whether copy-paste functionality is enabled for the Azure Bastion Host. Default is true.
- `file_copy_enabled` - Specifies whether file copy functionality is enabled for the Azure Bastion Host. Default is true.
- `idle_timeout_in_minutes` - The idle timeout in minutes for the Azure Bastion Host. Default is 4.
- `tags` - Tags of the resource. Default is {}.
- `domain_name_label` - The domain name label of the Azure Bastion Host. Default is null.
- `zones` - The availability zones of the Azure Bastion Host. Default is [].

  DESCRIPTION

  validation {
    condition     = can(regex("^(Basic|Standard|Developer|Premium)$", var.bastion.sku))
    error_message = "The SKU must be either 'Basic', 'Standard', 'Developer', or 'Premium'."
  }
  validation {
    condition     = var.bastion.session_recording_enabled == true ? var.bastion.sku == "Premium" : true
    error_message = "Session recording functionality is only availble for Premium SKU."
  }
  validation {
    condition     = var.bastion.ip_connect_enabled == true ? (var.bastion.sku == "Standard" || var.bastion.sku == "Premium") : true
    error_message = "IP Based connection functionality is only availble for Standard or Premium SKU."
  }
  validation {
    condition     = var.bastion.virtual_network_id != null ? var.bastion.sku == "Developer" : true
    error_message = "Virtual Network ID functionality is only availble for Developer SKU."
  }
}