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
    name               = "test-bastion-developer"
    sku                = "Developer"
    virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet"
  }
}

run "developer_sku_deployment" {
  command = plan

  assert {
    condition     = azapi_resource.bastion.body.sku.name == "Developer"
    error_message = "Expected SKU to be 'Developer'"
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.virtualNetwork.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet"
    error_message = "Expected virtualNetwork to reference the provided virtual network ID"
  }

  assert {
    condition     = length(azurerm_public_ip.this) == 0
    error_message = "Expected no public IP to be created for Developer SKU"
  }
}

run "developer_sku_with_network_acls" {
  command = plan

  variables {
    bastion = {
      name               = "test-bastion-developer-acls"
      sku                = "Developer"
      virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet"
      network_acls = {
        ip_rules = [
          { address_prefix = "10.0.0.0/24" },
          { address_prefix = "192.168.1.0/24" }
        ]
      }
    }
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.networkAcls.ipRules[0].addressPrefix == "10.0.0.0/24"
    error_message = "Expected first IP rule to be 10.0.0.0/24"
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.networkAcls.ipRules[1].addressPrefix == "192.168.1.0/24"
    error_message = "Expected second IP rule to be 192.168.1.0/24"
  }
}
