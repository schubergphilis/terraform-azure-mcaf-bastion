output "ids" {
  description = "A map of Azure Bastion Host IDs."
  value       = { for k, bastion in azurerm_bastion_host.this : k => bastion.id }
}

output "names" {
  description = "A map of Azure Bastion Host names."
  value       = { for k, bastion in azurerm_bastion_host.this : k => bastion.name }
}
