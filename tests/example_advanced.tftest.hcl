mock_provider "azurerm" {}

mock_provider "azapi" {}

run "advanced_example_plan" {
  command = plan
  module {
    source = "./examples/advanced"
  }
}
