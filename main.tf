resource "azurerm_bastion_host" "this" {
  for_each = var.bastion

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  copy_paste_enabled     = lookup(each.value, "copy_paste_enabled", false)
  file_copy_enabled      = lookup(each.value, "file_copy_enabled", false)
  ip_connect_enabled     = lookup(each.value, "ip_connect_enabled", false)
  kerberos_enabled       = lookup(each.value, "kerberos_enabled", false)
  scale_units            = lookup(each.value, "scale_units", 1)
  shareable_link_enabled = lookup(each.value, "shareable_link_enabled", false)
  sku                    = lookup(each.value, "sku", "Standard")
  tunneling_enabled      = lookup(each.value, "tunneling_enabled", false)
  virtual_network_id     = lookup(each.value, "virtual_network_id", null)
  tags                   = lookup(each.value, "tags", {})

  ip_configuration {
    name                 = each.value.ip_configuration.name
    subnet_id            = each.value.ip_configuration.subnet_id
    public_ip_address_id = each.value.ip_configuration.public_ip_address_id
  }
}
