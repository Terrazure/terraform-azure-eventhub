provider "azurerm" {
  features {}
}

variable "sku" {
  type    = string
  default = "Standard"
}
variable "capacity" {
  type    = number
  default = 2
}
variable "partitions" {
  type    = number
  default = 2
}
variable "retention" {
  type    = number
  default = 1
}

locals {
  location = "eastus"
}

resource "azurerm_resource_group" "group" {
  name     = "test-rg"
  location = local.location
}

module "namespace" {
  source = "../../"

  location            = local.location
  resource_group_name = azurerm_resource_group.group.name
  workload_name       = "test-ns"
  sku                 = var.sku
  capacity            = var.capacity

  hubs = [
    {
      partitions        = var.partitions
      message_retention = var.retention
    }
  ]

  authorized_ips_or_cidr_blocks = ["103.59.73.0/24"]
}
