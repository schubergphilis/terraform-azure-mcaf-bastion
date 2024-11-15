# Azure Bastion Example

## Overview

This example demonstrates how to use the Azure Bastion module with existing resources such as a Virtual Network (VNet) and subnet. It references these resources using Terraform data sources.

## Prerequisites

- **Terraform**: Ensure you have Terraform installed. This configuration requires Terraform version `>= 1.0.0`.
- **Azure Subscription**: An active Azure subscription with permissions to create resources.

## Usage

To use this example, create a `terraform.tfvars` file with the appropriate values and run Terraform.

### Example `terraform.tfvars`

```hcl
# Resource group and location for network resources
network_resource_group_name = "test-network-rg"

# Resource group and location for Bastion resources
bastion_resource_group_name = "test-bastion-rg"
location                    = "eastus"

# Virtual network and subnet
vnet_name    = "test-vnet"
subnet_name  = "AzureBastionSubnet"

# Bastion configuration
bastion = {
  name                    = "test-bastion"
  public_ip_name          = "test-public-ip"
  copy_paste_enabled      = true
  file_copy_enabled       = true
  scale_units             = 2
  idle_timeout_in_minutes = 5
  tags = {
    Environment = "Production"
    Owner       = "Infrastructure Team"
  }
  zones                   = ["1"]
  domain_name_label       = "test-domain-label"
}