# Terraform Azure Bastion Module

This Terraform module deploys one or more Azure Bastion Hosts.

## Usage

```hcl
module "azure_bastion" {
  source = "./path_to_your_module"

  bastion = {
    bastion1 = {
      location            = "eastus"
      name                = "bastion-eastus"
      resource_group_name = "my-resource-group"

      ip_configuration = {
        name                 = "ipconfig1"
        subnet_id            = azurerm_subnet.bastion_subnet_eastus.id
        public_ip_address_id = azurerm_public_ip.bastion_pip_eastus.id
      }

      # Optional attributes (defaults will be used if omitted)
      copy_paste_enabled     = true
      file_copy_enabled      = true
      scale_units            = 2
      tags = {
        Environment = "Production"
        Owner       = "Team A"
      }
    }

    bastion2 = {
      location            = "westus"
      name                = "bastion-westus"
      resource_group_name = "my-resource-group"

      ip_configuration = {
        name                 = "ipconfig1"
        subnet_id            = azurerm_subnet.bastion_subnet_westus.id
        public_ip_address_id = azurerm_public_ip.bastion_pip_westus.id
      }

      # Optional attributes can be omitted
    }
  }
}
