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
  name     = "rg-bastion-developer"
  location = "westeurope"
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-bastion-developer"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/16"]
}

# Developer SKU uses virtualNetwork instead of a dedicated subnet.
# No AzureBastionSubnet or Public IP is required.

module "bastion" {
  source = "../../"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  bastion = {
    name               = "bas-developer"
    sku                = "Developer"
    virtual_network_id = azurerm_virtual_network.this.id

    # Network ACLs restrict access to the Developer Bastion Host
    # to specific IP ranges (IPv4 CIDR only).
    network_acls = {
      ip_rules = [
        { address_prefix = "198.51.100.0/24" },
        { address_prefix = "203.0.113.0/24" },
      ]
    }

    tags = {
      Component = "Bastion Developer"
    }
  }

  tags = {
    Environment = "development"
    ManagedBy   = "Terraform"
  }
}

output "bastion_dns_name" {
  value = module.bastion.dns_name
}

output "bastion_id" {
  value = module.bastion.resource_id
}
