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
    name      = "test-bastion-basic"
    subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureBastionSubnet"
    sku       = "Basic"
  }
}

run "basic_sku_deployment" {
  command = plan

  assert {
    condition     = azapi_resource.bastion.body.sku.name == "Basic"
    error_message = "Expected SKU to be 'Basic'"
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.enableKerberos == false
    error_message = "Expected Kerberos to be disabled by default"
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.scaleUnits == 2
    error_message = "Expected scale units to be 2 for Basic SKU"
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.disableCopyPaste == false
    error_message = "Expected copy/paste to be enabled (disableCopyPaste=false) by default"
  }

  assert {
    condition     = length(azurerm_public_ip.this) == 1
    error_message = "Expected a public IP to be created for Basic SKU"
  }
}

run "basic_sku_with_kerberos" {
  command = plan

  variables {
    bastion = {
      name             = "test-bastion-basic-kerberos"
      subnet_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureBastionSubnet"
      sku              = "Basic"
      kerberos_enabled = true
    }
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.enableKerberos == true
    error_message = "Expected Kerberos to be enabled"
  }
}
