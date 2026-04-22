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
    subnet_id                 = optional(string, null)
    virtual_network_id        = optional(string, null)
    sku                       = optional(string, "Standard")
    kerberos_enabled          = optional(bool, false)
    scale_units               = optional(number, 2)
    tunneling_enabled         = optional(bool, false)
    shareable_link_enabled    = optional(bool, false)
    session_recording_enabled = optional(bool, false)
    private_only_enabled      = optional(bool, false)
    ip_connect_enabled        = optional(bool, false)
    copy_paste_enabled        = optional(bool, true)
    file_copy_enabled         = optional(bool, false)
    idle_timeout_in_minutes   = optional(number, null)
    public_ip_name            = optional(string, null)
    domain_name_label         = optional(string, null)
    tags                      = optional(map(string), {})
    zones                     = optional(list(string), [])
    network_acls = optional(object({
      ip_rules = optional(list(object({
        address_prefix = string
      })), [])
    }))
  })
  description = <<DESCRIPTION
The Azure Bastion Host configuration.

- `name` - The name of the Azure Bastion Host.
- `subnet_id` - The ID of the subnet where the Azure Bastion Host will be deployed. Required for Basic, Standard, and Premium SKUs.
- `virtual_network_id` - The ID of the virtual network where the Azure Bastion Host will be deployed. Required for Developer SKU only.
- `sku` - The SKU of the Azure Bastion Host. Default is 'Standard'. Valid values are 'Basic', 'Standard', 'Developer' or 'Premium'.
- `kerberos_enabled` - Specifies whether Kerberos authentication is enabled for the Azure Bastion Host. Default is false.
- `scale_units` - The number of scale units for the Azure Bastion Host. Default is 2. Configurable (2-50) for Standard and Premium SKUs only.
- `tunneling_enabled` - Specifies whether tunneling functionality is enabled for the Azure Bastion Host. Default is false. Standard or Premium SKU only.
- `shareable_link_enabled` - Specifies whether shareable link functionality is enabled for the Azure Bastion Host. Default is false. Standard or Premium SKU only.
- `session_recording_enabled` - Specifies whether session recording functionality is enabled for the Azure Bastion Host. Default is false. Premium SKU only.
- `private_only_enabled` - Specifies whether the private only mode is enabled for the Azure Bastion Host. Default is false. Premium SKU only.
- `ip_connect_enabled` - Specifies whether IP connect functionality is enabled for the Azure Bastion Host. Default is false. Standard or Premium SKU only.
- `copy_paste_enabled` - Specifies whether copy-paste functionality is enabled for the Azure Bastion Host. Default is true. Disabling is only supported on Standard or Premium SKU.
- `file_copy_enabled` - Specifies whether file copy functionality is enabled for the Azure Bastion Host. Default is false. Standard or Premium SKU only.
- `idle_timeout_in_minutes` - (Deprecated) This attribute is unused. Use `public_ip.idle_timeout_in_minutes` instead.
- `public_ip_name` - (Deprecated) This attribute is unused. Use `public_ip.name` instead.
- `domain_name_label` - (Deprecated) This attribute is unused. Use `public_ip.domain_name_label` instead.
- `tags` - Tags of the resource. Default is {}.
- `zones` - The availability zones of the Azure Bastion Host. Default is [].
- `network_acls` - Network ACL rules for the Azure Bastion Host. Developer SKU only.

  DESCRIPTION

  validation {
    condition     = can(regex("^(Basic|Standard|Developer|Premium)$", var.bastion.sku))
    error_message = "The SKU must be either 'Basic', 'Standard', 'Developer', or 'Premium'."
  }
  validation {
    condition     = var.bastion.session_recording_enabled == true ? var.bastion.sku == "Premium" : true
    error_message = "Session recording is only available for Premium SKU."
  }
  validation {
    condition     = var.bastion.private_only_enabled == true ? var.bastion.sku == "Premium" : true
    error_message = "Private-only deployment is only available for Premium SKU."
  }
  validation {
    condition     = var.bastion.ip_connect_enabled == true ? contains(["Standard", "Premium"], var.bastion.sku) : true
    error_message = "IP connect is only available for Standard or Premium SKU."
  }
  validation {
    condition     = var.bastion.file_copy_enabled == true ? contains(["Standard", "Premium"], var.bastion.sku) : true
    error_message = "File copy is only available for Standard or Premium SKU."
  }
  validation {
    condition     = var.bastion.shareable_link_enabled == true ? contains(["Standard", "Premium"], var.bastion.sku) : true
    error_message = "Shareable link is only available for Standard or Premium SKU."
  }
  validation {
    condition     = var.bastion.tunneling_enabled == true ? contains(["Standard", "Premium"], var.bastion.sku) : true
    error_message = "Tunneling is only available for Standard or Premium SKU."
  }
  validation {
    condition     = var.bastion.copy_paste_enabled == false ? contains(["Standard", "Premium"], var.bastion.sku) : true
    error_message = "Disabling copy/paste is only supported on Standard or Premium SKU."
  }
  validation {
    condition     = var.bastion.scale_units != 2 ? contains(["Standard", "Premium"], var.bastion.sku) : true
    error_message = "Configuring scale units is only available for Standard or Premium SKU."
  }
  validation {
    condition     = var.bastion.virtual_network_id != null ? var.bastion.sku == "Developer" : true
    error_message = "Virtual Network ID is only available for Developer SKU."
  }
  validation {
    condition     = var.bastion.sku == "Developer" ? var.bastion.virtual_network_id != null : true
    error_message = "Developer SKU requires virtual_network_id to be set."
  }
  validation {
    condition     = var.bastion.sku != "Developer" ? var.bastion.subnet_id != null : true
    error_message = "subnet_id is required for Basic, Standard, and Premium SKUs."
  }
  validation {
    condition     = var.bastion.network_acls != null ? var.bastion.sku == "Developer" : true
    error_message = "Network ACLs are only available for Developer SKU."
  }
}