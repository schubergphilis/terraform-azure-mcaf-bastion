variable "bastion" {
  description = "Configuration for the Azure Bastion Host"
  type = object({
    location            = string                   # The Azure region where the Bastion Host will be deployed.
    resource_group_name = string                   # The name of the resource group for the resources.
    subnet_id           = string                   # The ID of the subnet for the Bastion Host (must be 'AzureBastionSubnet').

    # Optional attributes with default values or null
    bastion_name            = optional(string)       # The name of the Azure Bastion Host.
    public_ip_name          = optional(string)       # The name of the Public IP address.
    copy_paste_enabled      = optional(bool)         # Enable or disable copy-paste functionality.
    file_copy_enabled       = optional(bool)         # Enable or disable file copy functionality.
    scale_units             = optional(number)       # The number of scale units for the Bastion Host.
    idle_timeout_in_minutes = optional(number)       # Idle timeout in minutes for the Public IP address.
    virtual_network_id      = optional(string)       # The ID of the virtual network (if applicable).
    tags                    = optional(map(string))  # Tags to assign to the resources.
  })
}
