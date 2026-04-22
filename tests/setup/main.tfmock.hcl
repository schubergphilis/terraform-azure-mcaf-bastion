mock_resource "azapi_resource" {
  defaults = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/bastionHosts/test-bastion"
    output = {
      properties = {
        dnsName = "bst-00000000-0000-0000-0000-000000000000.bastion.azure.com"
      }
    }
  }
}

mock_resource "azurerm_public_ip" {
  defaults = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/publicIPAddresses/test-bastion-pip"
  }
}

mock_data "azurerm_subscription" {
  defaults = {
    subscription_id = "00000000-0000-0000-0000-000000000000"
    display_name    = "test-subscription"
    tenant_id       = "00000000-0000-0000-0000-000000000000"
  }
}
