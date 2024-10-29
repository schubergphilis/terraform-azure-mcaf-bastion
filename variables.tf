variable "bastion" {
  description = "Map of Azure Bastion Host configurations"

  type = map(object({
    location            = string # The location of the Azure Bastion Host.
    name                = string # The name of the Azure Bastion Host.
    resource_group_name = string # The name of the resource group.

    ip_configuration = object({
      name                 = string # The name of the IP configuration.
      subnet_id            = string # The ID of the subnet for the Bastion Host.
      public_ip_address_id = string # The ID of the public IP address associated with the Azure Bastion Host.
    })

    copy_paste_enabled     = bool        # Enable or disable copy-paste functionality.
    file_copy_enabled      = bool        # Enable or disable file copy functionality.
    ip_connect_enabled     = bool        # Enable or disable IP connect.
    kerberos_enabled       = bool        # Enable or disable Kerberos authentication.
    scale_units            = number      # The number of scale units.
    shareable_link_enabled = bool        # Enable or disable shareable links.
    sku                    = string      # The SKU of the Bastion Host.
    tunneling_enabled      = bool        # Enable or disable tunneling.
    virtual_network_id     = string      # The ID of the virtual network.
    tags                   = map(string) # A mapping of tags to assign to the resource.
  }))

  default = {}
}
