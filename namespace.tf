resource "azurerm_eventhub_namespace" "ehn" {
  name                     = module.naming.eventhub_namespace.name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  sku                      = var.sku
  auto_inflate_enabled     = local.auto_inflate_enabled
  maximum_throughput_units = var.maximum_throughput_units
  capacity                 = var.capacity

  identity {
    type         = var.user_assigned_ids != null ? "SystemAssigned, UserAssigned" : "SystemAssigned"
    identity_ids = var.user_assigned_ids
  }

  dynamic "network_rulesets" {
    for_each = var.sku == "Basic" ? [] : ["true"]
    content {
      default_action                 = "Deny"
      trusted_service_access_enabled = true

      virtual_network_rule = [
        for subnet in var.authorized_vnet_subnet_ids : {
          subnet_id                                       = subnet
          ignore_missing_virtual_network_service_endpoint = false
      }]

      ip_rule = [
        for ip_range in var.authorized_ips_or_cidr_blocks : {
          ip_mask = ip_range
          action  = "Allow"
      }]
    }
  }

  tags = var.tags
}
