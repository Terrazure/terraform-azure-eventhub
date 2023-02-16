locals {
  redundancy           = var.sku == "Basic" ? null : var.zone_redundant
  auto_inflate_enabled = var.sku == "Basic" || var.maximum_throughput_units == null ? false : true
}