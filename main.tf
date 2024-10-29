resource "azurerm_bastion_host" "this" {
  for_each = var.bastion

  location               = each.value.location
  name                   = each.value.name
  resource_group_name    = each.value.resource_group_name
  copy_paste_enabled     = each.value.copy_paste_enabled
  file_copy_enabled      = each.value.file_copy_enabled
  ip_connect_enabled     = each.value.ip_connect_enabled
  kerberos_enabled       = each.value.kerberos_enabled
  scale_units            = each.value.scale_units
  shareable_link_enabled = each.value.shareable_link_enabled
  sku                    = each.value.sku
  tags                   = each.value.tags
  tunneling_enabled      = each.value.tunneling_enabled
  virtual_network_id     = each.value.virtual_network_id

  dynamic "ip_configuration" {
    for_each = [each.value.ip_configuration]
    content {
      name                 = ip_configuration.value.name
      public_ip_address_id = ip_configuration.value.public_ip_address_id
      subnet_id            = ip_configuration.value.subnet_id
    }
  }
}
