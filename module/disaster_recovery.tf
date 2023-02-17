resource "azurerm_eventhub_namespace_disaster_recovery_config" "this" {
  count = var.disaster_recovery_config.dr_enabled && var.sku == "Standard" ? 1 : 0

  name                 = module.naming.eventhub_namespace_disaster_recovery_config
  resource_group_name  = var.resource_group_name
  namespace_name       = azurerm_eventhub_namespace.ehn.name
  partner_namespace_id = var.disaster_recovery_config.partner_namespace_id

  depends_on = [azurerm_eventhub_namespace.ehn]
}
