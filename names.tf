module "naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.workload_name]
}

module "naming_eventhub" {
  source                 = "Azure/naming/azurerm"
  suffix                 = [var.workload_name]
  unique-include-numbers = true
}
