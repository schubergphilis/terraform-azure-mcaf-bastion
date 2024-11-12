provider "azurerm" {
  features {}
}

module "bastion_setup" {
  source = "./path_to_your_bastion_module" # Path to your Bastion module directory

  resource_group_name = "example-rg"
  location            = "eastus"
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes = {
    "AzureBastionSubnet" = "10.0.1.0/24"
  }
  nsg_resource_group_name = "example-nsg-rg"

  bastion = {
    name                    = "example-bastion"
    public_ip_name          = "example-public-ip"
    copy_paste_enabled      = true
    file_copy_enabled       = true
    scale_units             = 2
    idle_timeout_in_minutes = 5
    tags = {
      Environment = "Production"
      Owner       = "Infrastructure Team"
    }

    zones             = ["1"]     
    domain_name_label = "example-domain-label"
  }
}


output "bastion_host_name" {
  value = module.bastion_setup.bastion_host_name
}

output "bastion_host_id" {
  value = module.bastion_setup.bastion_host_id
}

output "public_ip_id" {
  value = module.bastion_setup.public_ip_id
}

output "public_ip_address" {
  value = module.bastion_setup.public_ip_address
}

output "vnet_id" {
  value = module.bastion_setup.vnet_id
}

output "subnet_id" {
  value = module.bastion_setup.subnet_id
}

output "resource_group_name" {
  value = module.bastion_setup.resource_group_name
}

output "nsg_id" {
  value = module.bastion_setup.nsg_id
}