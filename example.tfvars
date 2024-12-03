# Resource group and location for network resources
network_resource_group_name = "test-network-rg"

# Resource group and location for Bastion resources
bastion_resource_group_name = "test-bastion-rg"
location                    = "eastus"

# Virtual network and subnet
vnet_name    = "test-vnet"
subnet_name  = "AzureBastionSubnet"

# Bastion configuration
bastion = {
  name                    = "test-bastion"
  public_ip_name          = "test-public-ip"
  copy_paste_enabled      = true
  file_copy_enabled       = true
  scale_units             = 2
  idle_timeout_in_minutes = 5
  tags = {
    Environment = "Production"
    Owner       = "Infrastructure Team"
  }
  zones                   = ["1"]
  domain_name_label       = "test-domain-label"
}