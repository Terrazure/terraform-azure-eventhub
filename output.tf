output "id" {
  description = "The EventHub Namespace ID."
  value       = azurerm_eventhub_namespace.ehn.id
}

output "name" {
  description = "The EventHub Namespace name."
  value       = azurerm_eventhub_namespace.ehn.name
}

output "identity" {
  description = "The EventHub Namespace SystemAssigned managed identity principal id."
  value       = azurerm_eventhub_namespace.ehn.identity[0].principal_id
}

output "default_primary_connection_string" {
  description = "The primary connection string for the authorization rule"
  value       = azurerm_eventhub_namespace.ehn.default_primary_connection_string
  sensitive   = true
}

output "default_primary_key" {
  description = "The primary access key for the authorization rule"
  value       = azurerm_eventhub_namespace.ehn.default_primary_key
  sensitive   = true
}
