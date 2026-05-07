locals {
  is_developer = var.bastion.sku == "Developer"
  needs_pip    = !local.is_developer && !var.bastion.private_only_enabled

  identity_system_assigned_user_assigned = (
    var.managed_identities.system_assigned &&
    length(var.managed_identities.user_assigned_resource_ids) > 0
    ) ? {
    this = {
      type         = "SystemAssigned, UserAssigned"
      identity_ids = var.managed_identities.user_assigned_resource_ids
    }
  } : null

  identity_system_assigned = var.managed_identities.system_assigned ? {
    this = {
      type         = "SystemAssigned"
      identity_ids = null
    }
  } : null

  identity_user_assigned = (
    length(var.managed_identities.user_assigned_resource_ids) > 0
    ) ? {
    this = {
      type         = "UserAssigned"
      identity_ids = var.managed_identities.user_assigned_resource_ids
    }
  } : null
}

data "azurerm_subscription" "current" {}

resource "azurerm_public_ip" "this" {
  count               = local.needs_pip ? 1 : 0
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
  name                      = var.bastion.name
  location                  = var.location
  parent_id                 = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  type                      = "Microsoft.Network/bastionHosts@2025-05-01"
  schema_validation_enabled = false # azapi provider does not yet include the 2025-05-01 schema; the API itself is available
  dynamic "identity" {
    for_each = coalesce(
      local.identity_system_assigned_user_assigned,
      local.identity_system_assigned,
      local.identity_user_assigned,
      {}
    )

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
  body = {
    sku = {
      name = var.bastion.sku
    }
    zones = var.bastion.zones
    properties = {
      disableCopyPaste         = !var.bastion.copy_paste_enabled
      enableFileCopy           = var.bastion.file_copy_enabled
      enableIpConnect          = var.bastion.ip_connect_enabled
      enableKerberos           = var.bastion.kerberos_enabled
      enablePrivateOnlyBastion = var.bastion.private_only_enabled
      enableSessionRecording   = var.bastion.session_recording_enabled
      enableShareableLink      = var.bastion.shareable_link_enabled
      enableTunneling          = var.bastion.tunneling_enabled
      scaleUnits               = var.bastion.scale_units

      ipConfigurations = local.is_developer ? null : [
        {
          name = "${var.bastion.name}-ipconfig"
          properties = merge(
            {
              privateIPAllocationMethod = "Dynamic"
              subnet = {
                id = var.bastion.subnet_id
              }
            },
            local.needs_pip ? {
              publicIPAddress = { id = azurerm_public_ip.this[0].id }
            } : {}
          )
        }
      ]

      virtualNetwork = local.is_developer ? { id = var.bastion.virtual_network_id } : null

      networkAcls = local.is_developer && var.bastion.network_acls != null ? {
        ipRules = [for rule in var.bastion.network_acls.ip_rules : {
          addressPrefix = rule.address_prefix
        }]
      } : null
    }
  }
  response_export_values = { dnsName = "properties.dnsName", identityPrincipalId = "identity.principalId" }
  tags = merge(
    try(var.tags),
    try(var.bastion.tags),
    tomap({
      "Resource Type" = "Azure Bastion"
    })
  )
}
