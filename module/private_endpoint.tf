resource "azurerm_private_endpoint" "private_endpoint" {
  count = length(var.private_endpoint)

  name                = "${module.naming.private_endpoint.name}-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint[count.index]
  tags                = var.tags

  private_service_connection {
    name                           = "${module.naming.private_service_connection.name}-${count.index + 1}"
    private_connection_resource_id = azurerm_eventhub_namespace.ehn.id
    subresource_names              = ["namespace"]
    is_manual_connection           = false
  }

  lifecycle {
    ignore_changes = [private_dns_zone_group, ]
  }
}
