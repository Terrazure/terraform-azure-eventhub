resource "azurerm_eventhub" "this" {
  count = length(var.hubs)

  name              = module.naming.eventhub.name
  namespace_id      = azurerm_eventhub_namespace.ehn.id
  partition_count   = var.hubs[count.index].partitions
  message_retention = var.hubs[count.index].message_retention
}