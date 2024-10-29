variable "bastion" {
  description = "Azure Bastion host configuration"

  type = map(object({
    location            = string                       # The location of the Azure Bastion Host.
    name                = string                       # The name of the Azure Bastion Host.
    resource_group_name = string                       # The name of the resource group.
    copy_paste_enabled  = optional(bool, false)        # Enable or disable copy-paste functionality.
    file_copy_enabled   = optional(bool, false)        # Enable or disable file copy functionality.

    ip_configuration = object({
      name                 = string                    # The name of the IP configuration.
      subnet_id            = string                    # The ID of the subnet for the Bastion Host.
      public_ip_address_id = string                    # The ID of the public IP address for the Bastion Host.
    })

    ip_connect_enabled     = optional(bool, false)     # Enable or disable IP connect.
    kerberos_enabled       = optional(bool, false)     # Enable or disable Kerberos authentication.
    scale_units            = optional(number, 1)       # The number of scale units.
    shareable_link_enabled = optional(bool, false)     # Enable or disable shareable links.
    sku                    = optional(string, "Standard") # The SKU of the Bastion Host.
    tunneling_enabled      = optional(bool, false)     # Enable or disable tunneling.
    virtual_network_id     = optional(string, null)    # The ID of the virtual network.
  }))

  default = {}
}
