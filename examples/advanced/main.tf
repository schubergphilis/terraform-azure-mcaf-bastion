terraform {
  required_version = ">= 1.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.5, < 5.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {}

resource "azurerm_resource_group" "this" {
  name     = "rg-bastion-advanced"
  location = "westeurope"
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-bastion-advanced"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/26"]
}

# Full-featured Premium Bastion deployment with a public IP.
# Enables all available Premium features including native client
# (tunneling), file copy, shareable links, and IP connect.
#
# Note: session recording is omitted because it cannot be enabled
# together with native client (tunneling). See the private example
# for a session recording deployment.

module "bastion" {
  source = "../../"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  bastion = {
    name                   = "bas-advanced"
    subnet_id              = azurerm_subnet.bastion.id
    sku                    = "Premium"
    kerberos_enabled       = true
    scale_units            = 4
    tunneling_enabled      = true
    shareable_link_enabled = true
    ip_connect_enabled     = true
    copy_paste_enabled     = true
    file_copy_enabled      = true
    zones                  = ["1", "2", "3"]

    tags = {
      Component = "Bastion"
    }
  }

  managed_identities = {
    system_assigned = true
  }

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

output "bastion_id" {
  value = module.bastion.resource_id
}
