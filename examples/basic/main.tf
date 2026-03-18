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
  name     = "rg-bastion-basic"
  location = "westeurope"
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-bastion-basic"
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

module "bastion" {
  source = "../../"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  bastion = {
    name      = "bas-basic"
    subnet_id = azurerm_subnet.bastion.id
    sku       = "Basic"
  }

  tags = {
    Environment = "dev"
  }
}
