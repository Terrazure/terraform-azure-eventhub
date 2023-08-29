resource "azurerm_eventhub" "this" {
  for_each = var.hubs

  name                = module.naming.eventhub.name
  namespace_name      = azurerm_eventhub_namespace.ehn.name
  resource_group_name = var.resource_group_name
  partition_count     = each.value.partitions
  message_retention   = each.value.message_retention
}