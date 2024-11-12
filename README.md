# Azure Bastion Module

## Overview

This Terraform module configures a comprehensive, secure, and scalable Azure environment incorporating network infrastructure and a Bastion Host for streamlined and secure administrative access. Ideal for enterprise environments, this module ensures best practices and scalability.

## Prerequisites

- **Terraform**: Ensure you have Terraform installed. This configuration requires Terraform version `>= 1.0.0`.
- **Azure Subscription**: An active Azure subscription with permissions to create resources.

## Usage

To use this module, create a Terraform configuration file in your project and reference this module’s location. Below is an example to get you started.

### Example Configuration

```hcl
provider "azurerm" {
  features {}
}

module "bastion_setup" {
  source = "./path_to_your_bastion_module"  # Path to your Bastion module directory

  resource_group_name = "example-rg"
  location            = "eastus"
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = {
    "AzureBastionSubnet" = "10.0.1.0/24"
  }

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
    
    # Additional attributes
    zones                   = ["1"]
    domain_name_label       = "example-domain-label"
  }
}

output "bastion_host_name" {
  value = module.bastion_setup.bastion_host_name
}