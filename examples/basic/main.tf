terraform {
  required_version = ">= 1.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.5, < 5.0"
    }
  }
}

resource "azurerm_resource_group" "bast" {
  name     = var.resource_group_name
  location = var.location

  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Resource Group"
    })
  )
}


module "bastion" {
  source = "../../"

  resource_group_name = var.resource_group_name
  location            = var.location

  bastion = {
    name               = "bastion"
    subnet_id          = data.azurerm_subnet.azurebastionsubnet.id
    tunneling_enabled  = true
    copy_paste_enabled = true
  }

  tags = var.tags

  depends_on = [azurerm_resource_group.bast]
}
