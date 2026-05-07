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
    name      = "test-bastion-identity"
    subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureBastionSubnet"
    sku       = "Standard"
  }
}

run "no_identity_by_default" {
  command = plan

  assert {
    condition     = length(azapi_resource.bastion.identity) == 0
    error_message = "Expected no identity block when managed_identities is not set"
  }
}

run "system_assigned_identity" {
  command = plan

  variables {
    managed_identities = {
      system_assigned = true
    }
  }

  assert {
    condition     = azapi_resource.bastion.identity[0].type == "SystemAssigned"
    error_message = "Expected identity type to be 'SystemAssigned'"
  }
}

run "user_assigned_identity" {
  command = plan

  variables {
    managed_identities = {
      user_assigned_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/test-identity"]
    }
  }

  assert {
    condition     = azapi_resource.bastion.identity[0].type == "UserAssigned"
    error_message = "Expected identity type to be 'UserAssigned'"
  }

  assert {
    condition     = contains(azapi_resource.bastion.identity[0].identity_ids, "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/test-identity")
    error_message = "Expected user-assigned identity ID to be present"
  }
}

run "system_and_user_assigned_identity" {
  command = plan

  variables {
    managed_identities = {
      system_assigned            = true
      user_assigned_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/test-identity"]
    }
  }

  assert {
    condition     = azapi_resource.bastion.identity[0].type == "SystemAssigned, UserAssigned"
    error_message = "Expected identity type to be 'SystemAssigned, UserAssigned'"
  }

  assert {
    condition     = contains(azapi_resource.bastion.identity[0].identity_ids, "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/test-identity")
    error_message = "Expected user-assigned identity ID to be present"
  }
}
