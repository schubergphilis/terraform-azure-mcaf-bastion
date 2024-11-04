variable "bastion" {
  description = "Map of Azure Bastion Host configurations"

  type = map(object({
    location            = string # The location of the Azure Bastion Host.
    name                = string # The name of the Azure Bastion Host.
    resource_group_name = string # The name of the resource group.

    ip_configuration = object({
      name      = string # The name of the IP configuration.
      subnet_id = string # The ID of the subnet for the Bastion Host.

      public_ip = object({
        name                    = string                 # The name of the Public IP.
        allocation_method       = string                 # Allocation method: 'Static' or 'Dynamic'.
        sku                     = string                 # SKU: 'Basic' or 'Standard'.
        idle_timeout_in_minutes = optional(number)       # Idle timeout in minutes.
        tags                    = optional(map(string))  # Tags for the Public IP.
        zones                   = optional(list(string)) # Availability zones.
      })
    })

    # Optional attributes for the Bastion Host (defaults will be used if omitted)
    copy_paste_enabled     = optional(bool, false)        # Enable or disable copy-paste functionality.
    file_copy_enabled      = optional(bool, false)        # Enable or disable file copy functionality.
    ip_connect_enabled     = optional(bool, false)        # Enable or disable IP connect.
    kerberos_enabled       = optional(bool, false)        # Enable or disable Kerberos authentication.
    scale_units            = optional(number, 2)          # The number of scale units.
    shareable_link_enabled = optional(bool, false)        # Enable or disable shareable links.
    sku                    = optional(string, "Standard") # The SKU of the Bastion Host.
    tunneling_enabled      = optional(bool, false)        # Enable or disable tunneling.
    virtual_network_id     = optional(string)             # The ID of the virtual network.
    tags                   = optional(map(string))        # Tags to assign to the Bastion Host.
  }))

  default = {}
}
