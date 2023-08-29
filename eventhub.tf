resource "azurerm_eventhub" "this" {
  count = length(var.hubs)

  name                = module.naming.eventhub.name
  namespace_name      = azurerm_eventhub_namespace.ehn.name
  resource_group_name = var.resource_group_name
  partition_count     = var.hubs[count.index].partitions
  message_retention   = var.hubs[count.index].message_retention
}