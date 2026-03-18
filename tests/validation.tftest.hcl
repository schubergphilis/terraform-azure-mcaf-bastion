mock_provider "azurerm" {
  source = "./tests/setup"
}

mock_provider "azapi" {
  source = "./tests/setup"
}

variables {
  resource_group_name = "test-rg"
  location            = "westeurope"
}

# --- Basic SKU: features that should NOT be allowed ---

run "basic_sku_rejects_tunneling" {
  command = plan

  variables {
    bastion = {
      name              = "test-bastion"
      subnet_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureBastionSubnet"
      sku               = "Basic"
      tunneling_enabled = true
    }
  }

  expect_failures = [var.bastion]
}

run "basic_sku_rejects_file_copy" {
  command = plan

  variables {
    bastion = {
      name              = "test-bastion"
      subnet_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureBastionSubnet"
      sku               = "Basic"
      file_copy_enabled = true
    }
  }

  expect_failures = [var.bastion]
}

run "basic_sku_rejects_ip_connect" {
  command = plan

  variables {
    bastion = {
      name               = "test-bastion"
      subnet_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureBastionSubnet"
      sku                = "Basic"
      ip_connect_enabled = true
    }
  }

  expect_failures = [var.bastion]
}

run "basic_sku_rejects_shareable_link" {
  command = plan

  variables {
    bastion = {
      name                   = "test-bastion"
      subnet_id              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureBastionSubnet"
      sku                    = "Basic"
      shareable_link_enabled = true
    }
  }

  expect_failures = [var.bastion]
}

run "basic_sku_rejects_disable_copy_paste" {
  command = plan

  variables {
    bastion = {
      name               = "test-bastion"
      subnet_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureBastionSubnet"
      sku                = "Basic"
      copy_paste_enabled = false
    }
  }

  expect_failures = [var.bastion]
}

run "basic_sku_rejects_custom_scale_units" {
  command = plan

  variables {
    bastion = {
      name        = "test-bastion"
      subnet_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureBastionSubnet"
      sku         = "Basic"
      scale_units = 4
    }
  }

  expect_failures = [var.bastion]
}

# --- Standard SKU: Premium-only features should NOT be allowed ---

run "standard_sku_rejects_session_recording" {
  command = plan

  variables {
    bastion = {
      name                      = "test-bastion"
      subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureBastionSubnet"
      sku                       = "Standard"
      session_recording_enabled = true
    }
  }

  expect_failures = [var.bastion]
}

run "standard_sku_rejects_private_only" {
  command = plan

  variables {
    bastion = {
      name                 = "test-bastion"
      subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureBastionSubnet"
      sku                  = "Standard"
      private_only_enabled = true
    }
  }

  expect_failures = [var.bastion]
}

# --- Developer SKU: must have virtual_network_id, rejects non-Developer features ---

run "developer_sku_rejects_missing_vnet_id" {
  command = plan

  variables {
    bastion = {
      name = "test-bastion"
      sku  = "Developer"
    }
  }

  expect_failures = [var.bastion]
}

run "developer_sku_rejects_tunneling" {
  command = plan

  variables {
    bastion = {
      name               = "test-bastion"
      sku                = "Developer"
      virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet"
      tunneling_enabled  = true
    }
  }

  expect_failures = [var.bastion]
}

run "developer_sku_rejects_session_recording" {
  command = plan

  variables {
    bastion = {
      name                      = "test-bastion"
      sku                       = "Developer"
      virtual_network_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet"
      session_recording_enabled = true
    }
  }

  expect_failures = [var.bastion]
}

# --- Cross-SKU: network_acls only for Developer ---

run "standard_sku_rejects_network_acls" {
  command = plan

  variables {
    bastion = {
      name      = "test-bastion"
      subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureBastionSubnet"
      sku       = "Standard"
      network_acls = {
        ip_rules = [{ address_prefix = "10.0.0.0/24" }]
      }
    }
  }

  expect_failures = [var.bastion]
}

# --- Cross-SKU: virtual_network_id only for Developer ---

run "standard_sku_rejects_virtual_network_id" {
  command = plan

  variables {
    bastion = {
      name               = "test-bastion"
      subnet_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureBastionSubnet"
      sku                = "Standard"
      virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet"
    }
  }

  expect_failures = [var.bastion]
}

# --- Non-Developer SKUs require subnet_id ---

run "standard_sku_rejects_missing_subnet_id" {
  command = plan

  variables {
    bastion = {
      name = "test-bastion"
      sku  = "Standard"
    }
  }

  expect_failures = [var.bastion]
}
