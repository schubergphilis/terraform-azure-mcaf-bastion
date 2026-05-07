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
    name                   = "test-bastion-premium"
    subnet_id              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureBastionSubnet"
    sku                    = "Premium"
    tunneling_enabled      = true
    ip_connect_enabled     = true
    shareable_link_enabled = true
    file_copy_enabled      = true
    kerberos_enabled       = true
    scale_units            = 10
  }
}

run "premium_sku_all_features" {
  command = plan

  assert {
    condition     = azapi_resource.bastion.body.sku.name == "Premium"
    error_message = "Expected SKU to be 'Premium'"
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.enableTunneling == true
    error_message = "Expected tunneling to be enabled"
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.enableIpConnect == true
    error_message = "Expected IP connect to be enabled"
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.enableShareableLink == true
    error_message = "Expected shareable link to be enabled"
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.enableFileCopy == true
    error_message = "Expected file copy to be enabled"
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.enableKerberos == true
    error_message = "Expected Kerberos to be enabled"
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.scaleUnits == 10
    error_message = "Expected scale units to be 10"
  }

  assert {
    condition     = length(azurerm_public_ip.this) == 1
    error_message = "Expected a public IP to be created for non-private Premium SKU"
  }
}

run "premium_sku_with_session_recording" {
  command = plan

  variables {
    bastion = {
      name                      = "test-bastion-premium-recording"
      subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureBastionSubnet"
      sku                       = "Premium"
      session_recording_enabled = true
      ip_connect_enabled        = true
      kerberos_enabled          = true
      shareable_link_enabled    = true
      scale_units               = 4
    }
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.enableSessionRecording == true
    error_message = "Expected session recording to be enabled"
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.enableIpConnect == true
    error_message = "Expected IP connect to be enabled alongside session recording"
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.enableKerberos == true
    error_message = "Expected Kerberos to be enabled alongside session recording"
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.enableShareableLink == true
    error_message = "Expected shareable link to be enabled alongside session recording"
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.enableTunneling == false
    error_message = "Expected tunneling to be disabled when session recording is enabled"
  }
}
