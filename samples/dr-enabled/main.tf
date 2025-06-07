module "primary_namespace" {
  source = "../../"

  location            = local.primary_location
  resource_group_name = azurerm_resource_group.group.name
  workload_name       = "primary-ns"
  sku                 = "Standard"
  capacity            = 2

  authorized_ips_or_cidr_blocks = ["103.59.73.254"]
  authorized_vnet_subnet_ids    = [azurerm_subnet.snet.id]

  disaster_recovery_config = {
    dr_enabled           = true
    partner_namespace_id = module.secondary_namespace.id
  }

  depends_on = [module.secondary_namespace]
  hubs = [
    {
      partitions        = 5
      message_retention = 2
    },
  ]
}

module "secondary_namespace" {
  source = "../../"

  location            = local.secondary_location
  resource_group_name = azurerm_resource_group.group.name
  workload_name       = "secondary-ns"
  sku                 = "Standard"
  capacity            = 15

  authorized_ips_or_cidr_blocks = ["103.59.73.254"]
  authorized_vnet_subnet_ids    = [azurerm_subnet.snet.id]
}