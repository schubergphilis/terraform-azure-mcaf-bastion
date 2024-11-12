output "resource_group_name" {
  description = "The name of the resource group."
  value       = module.network.resource_group_name
}

output "vnet_id" {
  description = "The ID of the virtual network."
  value       = module.network.vnet_id
}

output "subnet_id" {
  description = "The ID of the Azure Bastion Subnet."
  value       = module.network.subnets["AzureBastionSubnet"]
}

output "bastion_host_id" {
  description = "The ID of the Azure Bastion Host."
  value       = azurerm_bastion_host.bastion.id
}

output "bastion_host_name" {
  description = "The name of the Azure Bastion Host."
  value       = azurerm_bastion_host.bastion.name
}

output "public_ip_id" {
  description = "The ID of the Public IP address."
  value       = azurerm_public_ip.bastion.id
}

output "public_ip_address" {
  description = "The IP address of the Public IP."
  value       = azurerm_public_ip.bastion.ip_address
}