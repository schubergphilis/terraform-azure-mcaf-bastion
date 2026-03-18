mock_provider "azurerm" {}

mock_provider "azapi" {}

run "basic_example_plan" {
  command = plan
  module {
    source = "./examples/basic"
  }
}
