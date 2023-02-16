<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.0.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.0.1 |

## Sample

<details>
<summary>Click to expand</summary>

```hcl
module "primary_namespace" {
  source = "../module"

  location            = local.primary_location
  resource_group_name = azurerm_resource_group.group.name
  workload_name       = "primary-ns"
  sku                 = "Standard"
  capacity            = 15

  authorized_ips_or_cidr_blocks = ["103.59.73.254"]
  authorized_vnet_subnet_ids    = [azurerm_subnet.snet.id]

  disaster_recovery_config = {
    dr_enabled           = true
    partner_namespace_id = module.secondary_namespace.id
  }

  depends_on = [module.secondary_namespace]
}

module "secondary_namespace" {
  source = "../module"

  location            = local.secondary_location
  resource_group_name = azurerm_resource_group.group.name
  workload_name       = "secondary-ns"
  sku                 = "Standard"
  capacity            = 15

  authorized_ips_or_cidr_blocks = ["103.59.73.254"]
  authorized_vnet_subnet_ids    = [azurerm_subnet.snet.id]
}
```
</details>

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_ips_or_cidr_blocks"></a> [authorized\_ips\_or\_cidr\_blocks](#input\_authorized\_ips\_or\_cidr\_blocks) | One or more IP Addresses, or CIDR Blocks which should be able to access the Eventhub Namespace. | `list(string)` | `[]` | no |
| <a name="input_authorized_vnet_subnet_ids"></a> [authorized\_vnet\_subnet\_ids](#input\_authorized\_vnet\_subnet\_ids) | IDs of the virtual network subnets authorized to connect to the Eventhub Namespace. | `list(string)` | `[]` | no |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | Specifies the Capacity / Throughput Units. Maximum value could be 20. | `number` | n/a | yes |
| <a name="input_disaster_recovery_config"></a> [disaster\_recovery\_config](#input\_disaster\_recovery\_config) | Specifies disaster recovery configuration. This block requires the following inputs:<br> - `dr_enabled`: If Geo-Recovery needs to be enabled?<br> - `partner_namespace_id` The ID of the EventHub Namespace to replicate to. | <pre>object({<br>    dr_enabled           = bool<br>    partner_namespace_id = string<br>  })</pre> | <pre>{<br>  "dr_enabled": false,<br>  "partner_namespace_id": ""<br>}</pre> | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the resource exists. | `string` | n/a | yes |
| <a name="input_maximum_throughput_units"></a> [maximum\_throughput\_units](#input\_maximum\_throughput\_units) | Specifies the maximum number of throughput units when Auto Inflate is Enabled. Valid values range from 1 - 20. This  option will enable 'Auto Inflate' capability of Eventhub namespace' | `number` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group where to deploy the EventHub Namespace. | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | Defines which tier to use. Valid options are Basic or Standard. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the Azure EventHub Namespace. | `map(string)` | `{}` | no |
| <a name="input_workload_name"></a> [workload\_name](#input\_workload\_name) | Specifies the workload name that will use this resource. This will be used in the resource name. | `string` | n/a | yes |
| <a name="input_zone_redundant"></a> [zone\_redundant](#input\_zone\_redundant) | Is zone\_redundancy enabled for the EventHub Namespace? | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_primary_connection_string"></a> [default\_primary\_connection\_string](#output\_default\_primary\_connection\_string) | The primary connection string for the authorization rule |
| <a name="output_default_primary_key"></a> [default\_primary\_key](#output\_default\_primary\_key) | The primary access key for the authorization rule |
| <a name="output_id"></a> [id](#output\_id) | The EventHub Namespace ID. |
| <a name="output_identity"></a> [identity](#output\_identity) | The EventHub Namespace SystemAssigned managed identity principal id. |
| <a name="output_name"></a> [name](#output\_name) | The EventHub Namespace name. |

## Resources

| Name | Type |
|------|------|
| [azurerm_eventhub_namespace.ehn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace) | resource |
| [azurerm_eventhub_namespace_disaster_recovery_config.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace_disaster_recovery_config) | resource |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_naming"></a> [naming](#module\_naming) | Azure/naming/azurerm | n/a |
<!-- END_TF_DOCS -->