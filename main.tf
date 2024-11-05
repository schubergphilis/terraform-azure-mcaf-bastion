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

resource "azurerm_resource_group" "this" {
  name     = var.bastion.resource_group_name
  location = var.bastion.location
}

resource "azurerm_public_ip" "this" {
  name                = lookup(var.bastion, "public_ip_name", "bastion-pip")
  resource_group_name = azurerm_resource_group.this.name
  location            = var.bastion.location
  allocation_method   = "Static"
  sku                 = "Standard"

  idle_timeout_in_minutes = lookup(var.bastion, "idle_timeout_in_minutes", 4)

  tags = lookup(var.bastion, "tags", {})

  # If you need to handle optional zones or other attributes, you can add them here using lookup()
}

resource "azurerm_bastion_host" "this" {
  name                = lookup(var.bastion, "bastion_name", "bastion-host")
  location            = var.bastion.location
  resource_group_name = azurerm_resource_group.this.name

  copy_paste_enabled     = lookup(var.bastion, "copy_paste_enabled", true)
  file_copy_enabled      = lookup(var.bastion, "file_copy_enabled", true)
  scale_units            = lookup(var.bastion, "scale_units", 2)
  sku                    = "Standard"
  virtual_network_id     = lookup(var.bastion, "virtual_network_id", null)

  tags = lookup(var.bastion, "tags", {})

  ip_configuration {
    name                 = "ipconfig1"
    subnet_id            = var.bastion.subnet_id
    public_ip_address_id = azurerm_public_ip.this.id
  }
}
