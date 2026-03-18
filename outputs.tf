output "dns_name" {
  description = "The FQDN of the Azure Bastion resource"
  value       = azapi_resource.bastion.output.properties.dnsName
}

output "name" {
  description = "The name of the Azure Bastion resource"
  value       = azapi_resource.bastion.name
}

output "resource" {
  description = "The Azure Bastion resource"
  value       = azapi_resource.bastion
}

output "resource_id" {
  description = "The ID of the Azure Bastion resource"
  value       = azapi_resource.bastion.id
}