
resource "azurerm_public_ip" "this" {
  name                = var.public_ip.name != null ? var.public_ip.name : "${var.bastion.name}-pip"
  resource_group_name = var.public_ip.resource_group_name != null ? var.public_ip.resource_group_name : var.resource_group_name
  location            = var.public_ip.location != null ? var.public_ip.location : var.location
  allocation_method   = var.public_ip.allocation_method
  sku                 = var.public_ip.sku

  idle_timeout_in_minutes = var.public_ip.idle_timeout_in_minutes

  zones             = var.public_ip.zones != null ? var.public_ip.zones : var.bastion.zones
  domain_name_label = var.public_ip.domain_name_label

  tags = merge(
    try(var.tags),
    try(var.public_ip.tags),
    tomap({
      "Resource Type" = "Public IP"
    })
  )
}

resource "azurerm_bastion_host" "this" {
  name                      = var.name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  copy_paste_enabled        = var.bastion.copy_paste_enabled
  file_copy_enabled         = var.bastion.file_copy_enabled
  ip_connect_enabled        = var.bastion.ip_connect_enabled
  kerberos_enabled          = var.bastion.kerberos_enabled
  scale_units               = var.bastion.scale_units
  session_recording_enabled = var.bastion.session_recording_enabled
  shareable_link_enabled    = var.bastion.shareable_link_enabled
  sku                       = var.bastion.sku
  tunneling_enabled         = var.bastion.tunneling_enabled
  virtual_network_id        = var.bastion.virtual_network_id

  ip_configuration {
    name                 = "${var.name}-ipconfig"
    subnet_id            = var.bastion.subnet_id
    public_ip_address_id = azurerm_public_ip.this.id
  }

  tags = merge(
    try(var.tags),
    try(var.bastion.tags),
    tomap({
      "Resource Type" = "Azure Bastion"
    })
  )

  depends_on = [azurerm_public_ip.this]
}