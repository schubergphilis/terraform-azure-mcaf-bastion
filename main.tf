terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Import the network module
module "network" {
  source = "github.com/schubergphilis/terraform-azure-mcaf-network"

  resource_group_name         = var.resource_group_name
  location                    = var.location
  address_space               = var.address_space
  subnet_prefixes             = var.subnet_prefixes

  # Additional variables required by the network module can be added here
}

resource "azurerm_public_ip" "bastion" {
  name                = lookup(var.bastion, "public_ip_name", "bastion-pip")
  resource_group_name = module.network.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  idle_timeout_in_minutes = lookup(var.bastion, "idle_timeout_in_minutes", 4)
  tags                    = lookup(var.bastion, "tags", {})

  # Handling optional attributes
  zones            = lookup(var.bastion, "zones", null)
  domain_name_label = lookup(var.bastion, "domain_name_label", null)
}

resource "azurerm_bastion_host" "this" {
  name                = lookup(var.bastion, "name", "bastion-host")
  location            = var.location
  resource_group_name = module.network.resource_group_name
  copy_paste_enabled  = lookup(var.bastion, "copy_paste_enabled", true)
  file_copy_enabled   = lookup(var.bastion, "file_copy_enabled", true)
  scale_units         = lookup(var.bastion, "scale_units", 2)
  sku                 = "Standard"
  virtual_network_id  = module.network.vnet_id

  tags = lookup(var.bastion, "tags", {})

  ip_configuration {
    name                 = "ipconfig1"
    subnet_id            = module.network.subnets["AzureBastionSubnet"]  # Ensure your subnet prefix mapping is correct
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}