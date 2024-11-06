output "bastion_host_id" {
  description = "The ID of the Azure Bastion Host."
  value       = azurerm_bastion_host.this.id
}

output "bastion_host_name" {
  description = "The name of the Azure Bastion Host."
  value       = azurerm_bastion_host.this.name
}

output "public_ip_id" {
  description = "The ID of the Public IP address."
  value       = azurerm_public_ip.this.id
}

output "public_ip_address" {
  description = "The IP address of the Public IP."
  value       = azurerm_public_ip.this.ip_address
}