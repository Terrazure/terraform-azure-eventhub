provider "azurerm" {
  features {}
}

variable "sku" { type = string }
variable "capacity" { type = number }
variable "zone_redundant" { type = bool }

locals {
  location = "eastus"
}

data "azurerm_subscription" "current" {}

resource "random_string" "workload_name" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "group" {
  name     = "test-rg-${random_string.workload_name.result}"
  location = local.location
}

module "namespace" {
  source = "../../"

  location            = local.location
  resource_group_name = azurerm_resource_group.group.name
  workload_name       = random_string.workload_name.result
  sku                 = var.sku
  zone_redundant      = var.zone_redundant
  capacity            = var.capacity

  authorized_ips_or_cidr_blocks = ["103.59.73.0/24"]
}

output "name" {
  value = module.namespace.name
}
output "resource_group_name" {
  value = azurerm_resource_group.group.name
}
output "subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}