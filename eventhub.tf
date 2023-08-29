resource "azurerm_eventhub" "this" {
  name                = module.naming.eventhub.name
  namespace_name      = azurerm_eventhub_namespace.ehn.name
  resource_group_name = var.resource_group_name
  partition_count     = var.partition_count
  message_retention   = var.message_retention
}