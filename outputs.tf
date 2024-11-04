output "bastion_host_ids" {
  description = "A map of Azure Bastion Host IDs."
  value       = { for k, bastion in azurerm_bastion_host.this : k => bastion.id }
}

output "bastion_host_names" {
  description = "A map of Azure Bastion Host names."
  value       = { for k, bastion in azurerm_bastion_host.this : k => bastion.name }
}

output "public_ip_ids" {
  description = "A map of Public IP IDs."
  value       = { for k, pip in azurerm_public_ip.public_ip : k => pip.id }
}

output "public_ip_addresses" {
  description = "A map of Public IP addresses."
  value       = { for k, pip in azurerm_public_ip.public_ip : k => pip.ip_address }
}
