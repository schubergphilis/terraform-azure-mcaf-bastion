mock_provider "azurerm" {
  source = "./tests/setup"
}

mock_provider "azapi" {
  source = "./tests/setup"
}

variables {
  resource_group_name = "test-rg"
  location            = "westeurope"
  tags                = { Environment = "test" }

  bastion = {
    name                 = "test-bastion-private"
    subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureBastionSubnet"
    sku                  = "Premium"
    private_only_enabled = true
  }
}

run "private_only_no_public_ip" {
  command = plan

  assert {
    condition     = azapi_resource.bastion.body.properties.enablePrivateOnlyBastion == true
    error_message = "Expected private-only to be enabled"
  }

  assert {
    condition     = length(azurerm_public_ip.this) == 0
    error_message = "Expected no public IP to be created for private-only deployment"
  }
}
