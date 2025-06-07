module "primary_namespace" {
  source = "../"

  location            = local.primary_location
  resource_group_name = azurerm_resource_group.group.name
  workload_name       = "primary-ns"
  sku                 = "Premium"
  capacity            = 15

  authorized_ips_or_cidr_blocks = ["103.59.73.254"]
  //authorized_vnet_subnet_ids    = [azurerm_subnet.snet.id]

  hubs = [
    {
      partitions        = 5
      message_retention = 2
    },
    {
      partitions        = 8
      message_retention = 1
    },
  ]

  private_endpoint = [azurerm_subnet.snet.id, ]
}
