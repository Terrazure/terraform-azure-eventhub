variable "resource_group_name" {
  type        = string
  description = "The resource group where to deploy the EventHub Namespace."
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists."
}

variable "workload_name" {
  type        = string
  description = "Specifies the workload name that will use this resource. This will be used in the resource name."
}

variable "sku" {
  type        = string
  description = "Defines which tier to use. Valid options are 'Basic', 'Standard' or 'Premium'."
  validation {
    condition     = (var.sku == "Basic" || var.sku == "Standard" || var.sku == "Premium")
    error_message = "Invalid sku. Valid options for sku are 'Basic', 'Standard' or 'Premium'."
  }
}

variable "capacity" {
  type        = number
  description = "Specifies the Capacity / Throughput Units. Maximum value could be 20."
  validation {
    condition     = var.capacity >= 1 && var.capacity <= 20
    error_message = "The Capacity of the Eventhub Namespace must be between 1 and 20."
  }
}

variable "maximum_throughput_units" {
  type        = number
  description = "Specifies the maximum number of throughput units when Auto Inflate is Enabled. Valid values range from 1 - 20. This  option will enable 'Auto Inflate' capability of Eventhub namespace'"
  validation {
    condition = (
      var.maximum_throughput_units == null ||
    coalesce(var.maximum_throughput_units, 1) >= 1 && coalesce(var.maximum_throughput_units, 20) <= 20)
    error_message = "The Max. throughput units of the Eventhub Namespace must be between 1 and 20."
  }
  default = null
}

variable "zone_redundant" {
  type        = bool
  description = "Is zone_redundancy enabled for the EventHub Namespace?"
  default     = false
}

variable "authorized_vnet_subnet_ids" {
  type        = list(string)
  description = "IDs of the virtual network subnets authorized to connect to the Eventhub Namespace."
  default     = []
}

variable "authorized_ips_or_cidr_blocks" {
  type        = list(string)
  description = "One or more IP Addresses, or CIDR Blocks which should be able to access the Eventhub Namespace."
  default     = []
}

variable "disaster_recovery_config" {
  type = object({
    dr_enabled           = bool
    partner_namespace_id = string
  })
  description = "Specifies disaster recovery configuration. This block requires the following inputs:\n - `dr_enabled`: If Geo-Recovery needs to be enabled?\n - `partner_namespace_id` The ID of the EventHub Namespace to replicate to."
  default = {
    dr_enabled           = false
    partner_namespace_id = ""
  }
}

variable "private_endpoint" {
  type        = list(string)
  description = "Specifies the private endpoint details for EventHub Namespace. List of  subnet IDs to use for the private endpoint of the EventHub Namespace."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags for the Azure EventHub Namespace."
  default     = {}
}

variable "hubs" {
  description = "A list of event hubs to add to the namespace. This block requires the following inputs:\n - `partitions` Specifies the current number of shards on the Event Hub. Valid values are from 1 to 32. The value cannot be changed unless Eventhub Namespace SKU is Premium. - `message_retention` Specifies the number of days to retain the events for this Event Hub. Valid values are from 1 to 7."
  type = list(object({
    partitions        = number
    message_retention = number
  }))
  validation {
    condition     = can(regex("^[[:digit:]]{1,2}$", var.hubs.partitions)) && var.hubs.partitions >= 1 && var.hubs.partitions <= 32
    error_message = "Invalid number of partitions."
  }
  validation {
    condition     = can(regex("^[[:digit:]]{1}$", var.hubs.message_retention)) && var.hubs.message_retention >= 1 && var.hubs.message_retention <= 7
    error_message = "Invalid number message retention days."
  }
}

variable "local_authentication_enabled" {
  type        = bool
  description = "Is SAS authentication enabled for the EventHub Namespace? Defaults to 'false'."
  default     = false
}

variable "user_assigned_ids" {
  type        = list(string)
  description = "The name of user assigned managed Identity to access KeyVault secrets. \n Kindly note that the identity must be assigned to the application/database/cache in the identity block."
  default     = null
}

