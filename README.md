# DEPRECATED - Azure Managed Mysql Service
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/db-mysql/azurerm/)

| ⚠ This module is deprecated, please use [db-mysql-flexible](https://registry.terraform.io/modules/claranet/db-mysql-flexible/azurerm/) module |
|--|

This Terraform module creates an [Azure MySQL server](https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html)
with [databases](https://www.terraform.io/docs/providers/azurerm/r/mysql_database.html)  and associated admin users along with logging activated and
[firewall rules](https://www.terraform.io/docs/providers/azurerm/r/mysql_firewall_rule.html).

## Requirements

* [MySQL Terraform provider](https://www.terraform.io/docs/providers/mysql/) >= 1.6

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 7.x.x       | 1.3.x             | >= 3.0          |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
}

module "mysql" {
  source  = "claranet/db-mysql/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  tier     = "GeneralPurpose"
  capacity = 4

  allowed_cidrs = {
    peered-vnet     = "10.0.0.0/24",
    customer-office = "12.34.56.78/32"
  }

  storage_mb                   = 5120
  backup_retention_days        = 10
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = false

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  databases = {
    "documents" = {
      "charset"   = "utf8"
      "collation" = "utf8_general_ci"
    }
  }

  force_ssl = true
  mysql_options = {
    interactive_timeout = "600",
    wait_timeout        = "260"
  }
  mysql_version = "5.7"

  threat_detection_policy = {
    email_addresses = ["john@doe.com"]
  }

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id
  ]

  extra_tags = {
    foo = "bar"
  }
}

provider "mysql" {
  endpoint = format("%s:3306", module.mysql.mysql_fqdn)
  username = format("%s@%s", var.administrator_login, module.mysql.mysql_server_name)
  password = var.administrator_password

  tls = true
}

module "mysql_users" {
  source  = "claranet/users/mysql"
  version = "x.x.x"

  for_each = toset(module.mysql.mysql_databases_names)

  user_suffix_enabled = true
  user                = each.key
  database            = each.key
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | ~> 3.22 |
| random | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | 6.2.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_mysql_configuration.mysql_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_configuration) | resource |
| [azurerm_mysql_database.mysql_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_database) | resource |
| [azurerm_mysql_firewall_rule.firewall_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_firewall_rule) | resource |
| [azurerm_mysql_server.mysql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_server) | resource |
| [azurerm_mysql_virtual_network_rule.vnet_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_virtual_network_rule) | resource |
| [random_password.mysql_administrator_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurecaf_name.mysql](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.mysql_dbs](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| administrator\_login | MySQL administrator login | `string` | n/a | yes |
| administrator\_password | MySQL administrator password. If not set, randomly generated | `string` | `""` | no |
| allowed\_cidrs | Map of authorized cidrs | `map(string)` | n/a | yes |
| allowed\_subnets | Map of authorized subnet ids | `map(string)` | `{}` | no |
| auto\_grow\_enabled | Enable/Disable auto-growing of the storage. | `bool` | `false` | no |
| backup\_retention\_days | Backup retention days for the server, supported values are between 7 and 35 days. | `number` | `10` | no |
| capacity | Capacity for MySQL server sku: https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#capacity | `number` | `4` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| custom\_server\_name | Custom Server Name identifier | `string` | `""` | no |
| databases | Map of databases with default collation and charset | `map(map(string))` | n/a | yes |
| default\_tags\_enabled | Option to enable or disable default tags | `bool` | `true` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Map of custom tags | `map(string)` | `{}` | no |
| force\_ssl | Enforce SSL connection | `bool` | `true` | no |
| force\_ssl\_minimal\_version | The minimal SSL version enforced | `string` | `"TLS1_2"` | no |
| geo\_redundant\_backup\_enabled | Turn Geo-redundant server backups on/off. Not available for the Basic tier. | `bool` | `true` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br>If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account. | `number` | `30` | no |
| mysql\_options | Map of configuration options: https://docs.microsoft.com/fr-fr/azure/mysql/howto-server-parameters#list-of-configurable-server-parameters. Merged with default\_mysql\_options local:<pre>log_bin_trust_function_creators = "ON"<br>    connect_timeout                 = 60<br>    interactive_timeout             = 28800<br>    wait_timeout                    = 28800</pre> | `map(string)` | `{}` | no |
| mysql\_version | Valid values are 5.6, 5.7 and 8.0 | `string` | `"5.7"` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| public\_network\_access\_enabled | Enable public network access for this server | `bool` | `false` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |
| storage\_mb | Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 4194304 MB(4TB) for General Purpose/Memory Optimized SKUs. | `number` | `5120` | no |
| threat\_detection\_policy | Threat detection policy configuration, known in the API as Server Security Alerts Policy | `any` | `null` | no |
| tier | Tier for MySQL server sku: https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#tier<br>Possible values are: GeneralPurpose, Basic, MemoryOptimized. | `string` | `"GeneralPurpose"` | no |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_server_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| use\_caf\_naming\_for\_databases | Use the Azure CAF naming provider to generate databases name. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| mysql\_administrator\_login | Administrator login for MySQL server |
| mysql\_administrator\_password | Administrator password for mysql server |
| mysql\_database\_ids | The list of all database resource ids |
| mysql\_databases | Map of databases infos |
| mysql\_databases\_names | List of databases names |
| mysql\_firewall\_rule\_ids | Map of MySQL created rules |
| mysql\_fqdn | FQDN of the MySQL server |
| mysql\_server\_id | MySQL server ID |
| mysql\_server\_name | MySQL server name |
| mysql\_vnet\_rules | The map of all vnet rules |
| terraform\_module | Information about this Terraform module |
<!-- END_TF_DOCS -->
## Related documentation

Microsoft Azure documentation: [docs.microsoft.com/fr-fr/azure/mysql/overview](https://docs.microsoft.com/fr-fr/azure/mysql/overview)
