## Inputs

### `bastion`

**Type**: `object`

**Description**: Configuration for the Azure Bastion Host.

#### Attributes:

- **Required**:
  - `location` *(string)*: The Azure region where the Bastion Host will be deployed.
  - `resource_group_name` *(string)*: The name of the resource group for the resources.
  - `subnet_id` *(string)*: The ID of the subnet for the Bastion Host (must be `AzureBastionSubnet`).

- **Optional**:
  - `bastion_name` *(string)*: The name of the Azure Bastion Host. Default is `"bastion-host"`.
  - `public_ip_name` *(string)*: The name of the Public IP address. Default is `"bastion-pip"`.
  - `copy_paste_enabled` *(bool)*: Enable or disable copy-paste functionality. Default is `true`.
  - `file_copy_enabled` *(bool)*: Enable or disable file copy functionality. Default is `true`.
  - `scale_units` *(number)*: The number of scale units for the Bastion Host. Default is `2`.
  - `idle_timeout_in_minutes` *(number)*: Idle timeout in minutes for the Public IP address. Default is `4`.
  - `virtual_network_id` *(string)*: The ID of the virtual network (if applicable). Default is `null`.
  - `tags` *(map(string))*: Tags to assign to the resources. Default is `{}`.

---

## Outputs

| Name                  | Description                         |
|-----------------------|-------------------------------------|
| `bastion_host_id`     | The ID of the Azure Bastion Host.   |
| `bastion_host_name`   | The name of the Azure Bastion Host. |
| `public_ip_id`        | The ID of the Public IP address.    |
| `public_ip_address`   | The IP address of the Public IP.    |

---

## Prerequisites

- **AzureBastionSubnet**: Ensure that the subnet specified by `subnet_id` exists and is named `AzureBastionSubnet`, as required by Azure.
- **Virtual Network**: The virtual network should be pre-created if you plan to use `virtual_network_id`.

---

## Notes

### Best Practices:

#### Public IP:

- `allocation_method` is set to `"Static"` (recommended for Bastion Hosts).
- `sku` is set to `"Standard"` (required for Azure Bastion).

#### Bastion Host:

- `sku` is set to `"Standard"`.
- `copy_paste_enabled` and `file_copy_enabled` default to `true` for enhanced functionality.
- `scale_units` default to `2` to provide scalability.

- **Tags**: Tags are optional but recommended for resource organization and management.
- **Scaling**: Adjust `scale_units` according to your expected load and performance requirements.

---

## Example

Here is a complete example of how to use this module:

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "my-resource-group"
  location = "eastus"
}

resource "azurerm_virtual_network" "example" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

module "azure_bastion" {
  source = "./path_to_your_module"

  bastion = {
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name
    subnet_id           = azurerm_subnet.bastion_subnet.id

    # Optional variables
    bastion_name        = "my-bastion-host"
    public_ip_name      = "my-bastion-pip"
    copy_paste_enabled  = true
    file_copy_enabled   = true
    scale_units         = 2
    tags = {
      Environment = "Production"
      Owner       = "Team A"
    }
  }
}
