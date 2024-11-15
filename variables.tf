variable "bastion" {
  description = "Configuration for the Azure Bastion Host"
  type = object({
    location              = string  # The Azure region where the Bastion Host will be deployed.
    resource_group_name   = string  # The name of the resource group for the Bastion resources.
    subnet_id             = string  # The ID of the subnet for the Bastion Host (must be 'AzureBastionSubnet').
    virtual_network_id    = string  # The ID of the virtual network.

    # Optional attributes with default values or null
    bastion_name            = optional(string, "bastion-host")
    public_ip_name          = optional(string, "bastion-pip")
    copy_paste_enabled      = optional(bool, true)
    file_copy_enabled       = optional(bool, true)
    scale_units             = optional(number, 2)
    idle_timeout_in_minutes = optional(number, 4)
    tags                    = optional(map(string), {})
    zones                   = optional(list(string), [])
    domain_name_label       = optional(string, null)
  })
}