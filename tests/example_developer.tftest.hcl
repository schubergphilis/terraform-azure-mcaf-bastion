mock_provider "azurerm" {}

mock_provider "azapi" {}

run "developer_example_plan" {
  command = plan
  module {
    source = "./examples/developer"
  }
}
