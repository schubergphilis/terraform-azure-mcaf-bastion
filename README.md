# terraform-azure-mcaf-key-vault
Terraform module to deploy a key vault with defaults, and optionaly some customer managed keys keys.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_key.cmkrsa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_key_vault"></a> [key\_vault](#input\_key\_vault) | This object describes the configuration for an Azure Key Vault.<br><br>The following arguments are supported:<br><br>- `name` - (Required) The name of the Key Vault.<br>- `tenant_id` - (Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the Key Vault.<br>- `resource_group_name` - (Required) The name of the resource group in which to create the Key Vault.<br>- `location` - (Optional) The location of the Key Vault. If not provided, the location of the calling module will be used.<br>- `enabled_for_disk_encryption` - (Optional) Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys.<br>- `enabled_for_deployment` - (Optional) Specifies whether Azure Resource Manager is permitted to retrieve secrets from the vault.<br>- `enabled_for_template_deployment` - (Optional) Specifies whether Azure Resource Manager is permitted to retrieve secrets from the vault.<br>- `enable_rbac_authorization` - (Optional) Specifies whether Azure RBAC is permitted to retrieve secrets from the vault.<br>- `purge_protection` - (Optional) Specifies whether protection against purge is enabled for this Key Vault.<br>- `soft_delete_retention_days` - (Optional) The number of days that items should be retained for once soft deleted.<br>- `default_action` - (Optional) The default action to apply when no rules match from network\_acls block.<br>- `sku` - (Optional) The SKU of the Key Vault.<br>- `ip_rules` - (Optional) List of IP addresses that are permitted to access the key vault.<br>- `subnet_ids` - (Optional) List of subnet IDs that are permitted to access the key vault.<br>- `network_bypass` - (Optional) Specifies which traffic can bypass the network rules.<br>- `cmk_keys_create` - (Optional) Specifies whether to create custom managed keys.<br>- `cmkrsa_key_name` - (Optional) The name of the customer managed key with RSA algorithm to create.<br>- `cmkec_key_name` - (Optional) The name of the customer managed key with EC algorithm to create.<br><br>Example Inputs:<pre>hcl<br>key_vault = {<br>  name                            = "my-key-vault"<br>  tenant_id                       = "00000000-0000-0000-0000-000000000000"<br>  enabled_for_disk_encryption     = true<br>  enabled_for_deployment          = true<br>  enabled_for_template_deployment = true<br>  enable_rbac_authorization       = true<br>  purge_protection                = true<br>  default_action                  = "Deny"<br>  soft_delete_retention_days      = 30<br>  sku                             = "standard"<br>  cmkrsa_key_name                  = "cmkrsa"<br>  cmkec_key_name                   = "cmkec"<br>  cmk_keys_create                 = true</pre> | <pre>object({<br>    name                            = string<br>    tenant_id                       = string<br>    resource_group_name             = string<br>    location                        = optional(string, null)<br>    enabled_for_disk_encryption     = optional(bool, false)<br>    enabled_for_deployment          = optional(bool, false)<br>    enabled_for_template_deployment = optional(bool, false)<br>    enable_rbac_authorization       = optional(bool, true)<br>    purge_protection                = optional(bool, true)<br>    soft_delete_retention_days      = optional(number, 30)<br>    public_network_access_enabled   = optional(bool, false)<br>    default_action                  = optional(string, "Deny")<br>    sku                             = optional(string, "standard")<br>    ip_rules                        = optional(list(string), [])<br>    subnet_ids                      = optional(list(string), [])<br>    network_bypass                  = optional(string, "None")<br>    cmk_keys_create                 = optional(bool, false)<br>    cmkrsa_key_name                 = optional(string, "cmkrsa")<br>    cmkec_key_name                  = optional(string, "cmkec")<br>    cmk_rotation_period             = optional(string, "P90D")<br>    tags                            = optional(map(string), {})<br>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resources. | `map(string)` | n/a | yes |
| <a name="input_key_vault_key"></a> [key\_vault\_key](#input\_key\_vault\_key) | This map describes the configuration for Azure Key Vault keys.<br><br>- `key_vault_id` - (Required) The ID of the Key Vault.<br>- `key_type` - (Required) The type of the key.<br>- `key_size` - (Required) The size of the key.<br>- `key_opts` - (Required) The key operations that are permitted.<br><br>Example Inputs:<pre>hcl<br>  key_vault_key = {<br>    key_rsa = {<br>      type = "RSA"<br>      size = 4096<br>      opts = ["encrypt", "decrypt", "sign", "verify", "wrapKey", "unwrapKey"]<br>    }<br>    key_ec = {<br>      type = "EC"<br>      curve = "P-256"<br>      opts = ["sign", "verify"]<br>    }<br>  }</pre> | <pre>map(object({<br>    name            = optional(string, null)<br>    curve           = optional(string, null)<br>    size            = optional(number, null)<br>    type            = optional(string, null)<br>    opts            = optional(list(string), null)<br>    expiration_date = optional(string, null)<br>    not_before_date = optional(string, null)<br>    rotation_policy = optional(object({<br>      automatic = optional(object({<br>        time_after_creation = optional(string, null)<br>        time_before_expiry  = optional(string, null)<br>      }), null)<br>      expire_after         = optional(string, null)<br>      notify_before_expiry = optional(string, null)<br>    }), null)<br>    tags = optional(map(string), {})<br>  }))</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_cmkrsa_id"></a> [key\_vault\_cmkrsa\_id](#output\_key\_vault\_cmkrsa\_id) | CMK RSA Key ID |
| <a name="output_key_vault_cmkrsa_key_name"></a> [key\_vault\_cmkrsa\_key\_name](#output\_key\_vault\_cmkrsa\_key\_name) | CMK RSA Key Name |
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | n/a |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | n/a |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | n/a |
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
