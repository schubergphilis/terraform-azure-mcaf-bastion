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

# Reference the network module
module "network" {
  source = "git::hhtps://github.com/schubergphilis/terraform-azure-mcaf-network"

  resource_group_name     = var.resource_group_name
  location                = var.location
  address_space           = var.address_space
  subnet_prefixes         = var.subnet_prefixes
  nsg_resource_group_name = var.nsg_resource_group_name # Assuming the NSG is created in this resource group
}

resource "azurerm_network_security_rule" "Allow_InterBastionTraffic_Inbound" {
  name                        = "Allow-Https-in-from-vnets"
  priority                    = 2000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["8080", "5701"]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = module.network.nsg_resource_group_name # Reference network module's output
  network_security_group_name = module.network.nsg_name                # Reference network module's output
}

resource "azurerm_network_security_rule" "Allow_SSH_RDP_Outbound" {
  name                        = "Allow_SSH_RDP_Outbound"
  priority                    = 2000
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["22", "3389"]
  source_address_prefix       = "*"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = module.network.nsg_resource_group_name
  network_security_group_name = module.network.nsg_name
}

resource "azurerm_network_security_rule" "Allow_HTTPS_AzureCloud_Outbound" {
  name                        = "Allow_HTTPS_AzureCloud_Outbound"
  priority                    = 2010
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "AzureCloud"
  resource_group_name         = module.network.nsg_resource_group_name
  network_security_group_name = module.network.nsg_name
}

resource "azurerm_network_security_rule" "Allow_InterBastionTraffic_Outbound" {
  name                        = "Allow_InterBastionTraffic_Outbound"
  priority                    = 2020
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["8080", "5701"]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = module.network.nsg_resource_group_name
  network_security_group_name = module.network.nsg_name
}

resource "azurerm_network_security_rule" "Allow_HTTPS_SessionInformation_Outbound" {
  name                        = "Allow_HTTPS_SessionInformation_Outbound"
  priority                    = 2030
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "Internet"
  resource_group_name         = module.network.nsg_resource_group_name
  network_security_group_name = module.network.nsg_name
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group.name
  location = var.resource_group.location
}

resource "azurerm_public_ip" "bastion" {
  name                = lookup(var.bastion, "public_ip_name", "bastion-pip")
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  idle_timeout_in_minutes = lookup(var.bastion, "idle_timeout_in_minutes", 4)
  tags                    = lookup(var.bastion, "tags", {})

  zones             = lookup(var.bastion, "zones", null)
  domain_name_label = lookup(var.bastion, "domain_name_label", null)
}

resource "azurerm_bastion_host" "bastion" {
  name                = lookup(var.bastion, "name", "bastion-host")
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  copy_paste_enabled  = lookup(var.bastion, "copy_paste_enabled", true)
  file_copy_enabled   = lookup(var.bastion, "file_copy_enabled", true)
  scale_units         = lookup(var.bastion, "scale_units", 2)
  sku                 = "Standard"
  virtual_network_id  = module.network.vnet_id

  tags = lookup(var.bastion, "tags", {})

  ip_configuration {
    name                 = "ipconfig1"
    subnet_id            = module.network.subnets["AzureBastionSubnet"]
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}