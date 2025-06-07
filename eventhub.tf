resource "azurerm_eventhub" "this" {
  count = length(var.hubs)

  name = "${module.naming.eventhub.name}-${(
    var.hubs[count.index].name_suffix != null && var.hubs[count.index].name_suffix != "" ?
    var.hubs[count.index].name_suffix : count.index
  )}"
  namespace_id      = azurerm_eventhub_namespace.ehn.id
  partition_count   = var.hubs[count.index].partitions
  message_retention = var.hubs[count.index].message_retention
}