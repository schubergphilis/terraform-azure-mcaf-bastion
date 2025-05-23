# terraform-azure-mcaf-bastion

The `terraform-azure-mcaf-bastion` module is a Terraform module designed to deploy and manage an Azure Bastion Host. Azure Bastion is a fully managed service that provides secure and seamless RDP and SSH connectivity to virtual machines directly through the Azure portal. This module simplifies the deployment of Azure Bastion by providing configurable options for various parameters such as SKU, subnet, virtual network, and additional features like Kerberos authentication, tunneling, and session recording.

### Features

- Deploys an Azure Bastion Host with configurable parameters.
- Supports multiple SKUs: Basic, Standard, Developer, and Premium.
- Enables optional features like Kerberos authentication, tunneling, session recording, and more.
- Allows customization of public IP address settings.
- Provides outputs for the Bastion Host's DNS name, resource name, resource object, and resource ID.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | ~> 2.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azapi_resource.bastion](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion"></a> [bastion](#input\_bastion) | The Azure Bastion Host configuration.<br/><br/>- `name` - The name of the Azure Bastion Host.<br/>- `location` - The location of the Azure Bastion Host.<br/>- `resource_group_name` - The name of the resource group where the Azure Bastion Host is located.<br/>- `subnet_id` - The ID of the subnet where the Azure Bastion Host will be deployed.<br/>- `virtual_network_id` - The ID of the virtual network where the Azure Bastion Host will be deployed. Default is null. only for Developer SKU.<br/>- `sku` - The SKU of the Azure Bastion Host. Default is 'Standard'. Valid values are 'Basic', 'Standard', 'Developer' or 'Premium'.<br/>- `kerberos_enabled` - Specifies whether Kerberos authentication is enabled for the Azure Bastion Host. Default is false.<br/>- `scale_units` - The number of scale units for the Azure Bastion Host. Default is 2.<br/>- `tunneling_enabled` - Specifies whether tunneling functionality is enabled for the Azure Bastion Host. Default is false.<br/>- `shareable_link_enabled` - Specifies whether shareable link functionality is enabled for the Azure Bastion Host. Default is false.<br/>- `private_only_enabled` - Specifies whether the private only mode is enabled for the Azure Bastion Host. Default is false.<br/>- `session_recording_enabled` - Specifies whether session recording functionality is enabled for the Azure Bastion Host. Default is false.<br/>- `public_ip_name` - The name of the public IP address associated with the Azure Bastion Host. Default is null.<br/>- `ip_connect_enabled` - Specifies whether IP connect functionality is enabled for the Azure Bastion Host. Default is false.<br/>- `copy_paste_enabled` - Specifies whether copy-paste functionality is enabled for the Azure Bastion Host. Default is true.<br/>- `file_copy_enabled` - Specifies whether file copy functionality is enabled for the Azure Bastion Host. Default is true.<br/>- `idle_timeout_in_minutes` - The idle timeout in minutes for the Azure Bastion Host. Default is 4.<br/>- `tags` - Tags of the resource. Default is {}.<br/>- `domain_name_label` - The domain name label of the Azure Bastion Host. Default is null.<br/>- `zones` - The availability zones of the Azure Bastion Host. Default is []. | <pre>object({<br/>    name                      = string<br/>    subnet_id                 = string<br/>    virtual_network_id        = optional(string, null)<br/>    sku                       = optional(string, "Standard")<br/>    kerberos_enabled          = optional(bool, false)<br/>    scale_units               = optional(number, 2)<br/>    tunneling_enabled         = optional(bool, false)<br/>    shareable_link_enabled    = optional(bool, false)<br/>    session_recording_enabled = optional(bool, false)<br/>    private_only_enabled      = optional(bool, false)<br/>    public_ip_name            = optional(string, null)<br/>    ip_connect_enabled        = optional(bool, false)<br/>    copy_paste_enabled        = optional(bool, false)<br/>    file_copy_enabled         = optional(bool, false)<br/>    idle_timeout_in_minutes   = optional(number, 4)<br/>    tags                      = optional(map(string), {})<br/>    domain_name_label         = optional(string, null)<br/>    zones                     = optional(list(string), [])<br/>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location of the Azure Bastion Host. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where the Azure Bastion resources are located. | `string` | n/a | yes |
| <a name="input_public_ip"></a> [public\_ip](#input\_public\_ip) | (Optional) The public IP address associated with the Azure Bastion Host. | <pre>object({<br/>    name                    = optional(string)<br/>    resource_group_name     = optional(string)<br/>    location                = optional(string)<br/>    allocation_method       = optional(string, "Static")<br/>    sku                     = optional(string, "Standard")<br/>    idle_timeout_in_minutes = optional(number)<br/>    tags                    = optional(map(string))<br/>    zones                   = optional(list(string), [])<br/>    domain_name_label       = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Tags of the resource. | `map(string)` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## License

**Copyright:** Schuberg Philis

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```