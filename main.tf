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
  features = {}
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_public_ip" "this" {
  name                = var.public_ip_name
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  idle_timeout_in_minutes = var.idle_timeout_in_minutes

  tags = var.tags
}

resource "azurerm_bastion_host" "this" {
  name                = var.bastion_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  copy_paste_enabled = var.copy_paste_enabled
  file_copy_enabled  = var.file_copy_enabled
  scale_units        = var.scale_units
  sku                = "Standard"
  virtual_network_id = var.virtual_network_id

  tags = var.tags

  ip_configuration {
    name                 = "ipconfig1"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.this.id
  }
}
