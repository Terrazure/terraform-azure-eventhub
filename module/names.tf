module "naming" {
  source  = "Azure/naming/azurerm"
  suffix = [ var.workload_name ]
}
