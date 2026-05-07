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
  name     = "rg-bastion-private"
  location = "westeurope"
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-bastion-private"
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

# Private-only Bastion deployment with session recording (no public IP).
# Requires Premium SKU. Access is only possible via private IP,
# ensuring no internet-routable endpoint is exposed.
#
# Note: session recording and native client (tunneling) cannot be
# enabled together -- tunneling and features that depend on it
# (file copy, shareable link) are omitted here.

module "bastion" {
  source = "../../"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  bastion = {
    name                      = "bas-private"
    subnet_id                 = azurerm_subnet.bastion.id
    sku                       = "Premium"
    private_only_enabled      = true
    session_recording_enabled = true
    kerberos_enabled          = true
    ip_connect_enabled        = true
    copy_paste_enabled        = true
    scale_units               = 4
    zones                     = ["1", "2", "3"]

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
