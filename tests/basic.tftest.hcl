run "basic" {
  variables {
    key_vault = {
      name                            = "kv001"
      resource_group_name             = "kvrg"
      tenant_id                       = "your-tenant-id"
      enabled_for_disk_encryption     = false
      enabled_for_deployment          = false
      enabled_for_template_deployment = false
      enable_rbac_authorization       = true
      purge_protection                = true
      soft_delete_retention_days      = 30
      sku                             = "standard"
      ip_rules                        = []
      subnet_ids                      = []
      network_bypass                  = "None"
      cmkrsa_key_name                 = "cmkrsa"
      cmkec_key_name                  = "cmkec"
      cmk_keys_create                 = true
    }

    tags = {
      Environment = "Production"
    }
  }

  module {
    source = "./"
  }

  command = plan

  assert {
    condition     = output.key_vault_name == "kv001"
    error_message = "Unexpected output.key_vault_name value"
  }

  assert {
    condition     = output.cmk_ec_key_name == "cmkec"
    error_message = "Unexpected output.cmk_ec_key_name value"
  }

}