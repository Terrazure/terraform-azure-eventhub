locals {
  auto_inflate_enabled = var.sku == "Basic" || var.maximum_throughput_units == null ? false : true
}