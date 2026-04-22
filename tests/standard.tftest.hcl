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
    name                   = "test-bastion-standard"
    subnet_id              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureBastionSubnet"
    sku                    = "Standard"
    tunneling_enabled      = true
    ip_connect_enabled     = true
    shareable_link_enabled = true
    file_copy_enabled      = true
    copy_paste_enabled     = true
    scale_units            = 4
  }
}

run "standard_sku_all_features" {
  command = plan

  assert {
    condition     = azapi_resource.bastion.body.sku.name == "Standard"
    error_message = "Expected SKU to be 'Standard'"
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
    condition     = azapi_resource.bastion.body.properties.disableCopyPaste == false
    error_message = "Expected copy/paste to be enabled (disableCopyPaste=false)"
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.scaleUnits == 4
    error_message = "Expected scale units to be 4"
  }

  assert {
    condition     = length(azurerm_public_ip.this) == 1
    error_message = "Expected a public IP to be created for Standard SKU"
  }
}

run "standard_sku_disable_copy_paste" {
  command = plan

  variables {
    bastion = {
      name               = "test-bastion-standard-nocp"
      subnet_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureBastionSubnet"
      sku                = "Standard"
      copy_paste_enabled = false
    }
  }

  assert {
    condition     = azapi_resource.bastion.body.properties.disableCopyPaste == true
    error_message = "Expected copy/paste to be disabled (disableCopyPaste=true)"
  }
}
