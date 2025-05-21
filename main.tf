resource "azurerm_public_ip" "this" {
  count = var.bastion.private_only_enabled ? 0 : 1
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

resource "azapi_resource" "bastion" {
  type = "Microsoft.Network/bastionHosts@2024-05-01"
  body = {
    sku = {
      name = var.bastion.sku
    }
    zones = var.bastion.zones
    properties = {
      disableCopyPaste         = var.bastion.copy_paste_enabled
      enableFileCopy           = var.bastion.file_copy_enabled
      enableIpConnect          = var.bastion.ip_connect_enabled
      enableKerberos           = var.bastion.kerberos_enabled
      enablePrivateOnlyBastion = var.bastion.private_only_enabled
      enableSessionRecording   = var.bastion.session_recording_enabled
      enableShareableLink      = var.bastion.shareable_link_enabled
      enableTunneling          = var.bastion.tunneling_enabled
      ipConfigurations = [
        {
          name = "${var.bastion.name}-ipconfig"
          properties = {
            privateIPAllocationMethod = "Dynamic"
            publicIPAddress           =  var.bastion.private_only_enabled ? null : azurerm_public_ip.this[0].id
            subnet = {
              id = var.bastion.subnet_id
            }
          }
        }
      ]
      scaleUnits = var.bastion.scale_units
    }
  }
  location  = var.location
  name      = var.bastion.name
  parent_id = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  response_export_values = ["properties.dnsName"]
  tags = merge(
    try(var.tags),
    try(var.bastion.tags),
    tomap({
      "Resource Type" = "Azure Bastion"
    })
  )
}
