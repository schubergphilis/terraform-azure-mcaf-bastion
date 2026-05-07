mock_provider "azurerm" {}

mock_provider "azapi" {}

run "private_example_plan" {
  command = plan
  module {
    source = "./examples/private"
  }
}
