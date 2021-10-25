# Azure Managed Mysql Service 
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/db-mysql/azurerm/)

This Terraform module creates an [Azure MySQL server](https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html) 
with [databases](https://www.terraform.io/docs/providers/azurerm/r/mysql_database.html)  and associated admin users along with logging activated and 
[firewall rules](https://www.terraform.io/docs/providers/azurerm/r/mysql_firewall_rule.html).

## Requirements

* [MySQL Terraform provider](https://www.terraform.io/docs/providers/mysql/) >= 1.6

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 5.x.x       | 0.15.x & 1.0.x    | >= 2.0          |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

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

  allowed_cidrs = ["10.0.0.0/24", "12.34.56.78/32"]

  storage_mb                   = 5120
  backup_retention_days        = 10
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = false

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  databases_names        = ["my_database"]

  force_ssl     = true
  mysql_options = [{ name = "interactive_timeout", value = "600" }, { name = "wait_timeout", value = "260" }]
  mysql_version = "5.7"
  databases_charset = {
    "my_database" = "utf8"
  }
  databases_collation = {
    "my_database" = "utf8_general_ci"
  }

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

```

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.23 |
| mysql.create-users | >= 1.6 |
| random | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | 4.0.3 |

## Resources

| Name | Type |
|------|------|
| [azurerm_mysql_configuration.mysql_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_configuration) | resource |
| [azurerm_mysql_database.mysql_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_database) | resource |
| [azurerm_mysql_firewall_rule.firewall_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_firewall_rule) | resource |
| [azurerm_mysql_server.mysql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_server) | resource |
| [azurerm_mysql_virtual_network_rule.vnet_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_virtual_network_rule) | resource |
| [mysql_grant.roles](https://registry.terraform.io/providers/terraform-providers/mysql/latest/docs/resources/grant) | resource |
| [mysql_user.users](https://registry.terraform.io/providers/terraform-providers/mysql/latest/docs/resources/user) | resource |
| [random_password.db_passwords](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| administrator\_login | MySQL administrator login | `string` | n/a | yes |
| administrator\_password | MySQL administrator password. Strong Password: https://docs.microsoft.com/en-us/sql/relational-databases/security/strong-passwords?view=sql-server-2017 | `string` | n/a | yes |
| allowed\_cidrs | List of authorized cidrs | `list(string)` | n/a | yes |
| allowed\_subnets | List of authorized subnet ids | `list(string)` | `[]` | no |
| auto\_grow\_enabled | Enable/Disable auto-growing of the storage. | `bool` | `false` | no |
| backup\_retention\_days | Backup retention days for the server, supported values are between 7 and 35 days. | `number` | `10` | no |
| capacity | Capacity for MySQL server sku: https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#capacity | `number` | `4` | no |
| client\_name | Name of client | `string` | n/a | yes |
| create\_databases\_users | True to create a user named <db>(\_user) per database with generated password. | `bool` | `true` | no |
| custom\_server\_name | Custom Server Name identifier | `string` | `""` | no |
| databases\_charset | Valid mysql charset: https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html | `map(string)` | `{}` | no |
| databases\_collation | Valid mysql collation: https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html | `map(string)` | `{}` | no |
| databases\_names | List of databases names | `list(string)` | n/a | yes |
| enable\_user\_suffix | True to append a \_user suffix to database users | `bool` | `true` | no |
| environment | Name of application's environnement | `string` | n/a | yes |
| extra\_tags | Map of custom tags | `map(string)` | `{}` | no |
| force\_ssl | Force usage of SSL | `bool` | `true` | no |
| geo\_redundant\_backup\_enabled | Turn Geo-redundant server backups on/off. Not available for the Basic tier. | `bool` | `true` | no |
| location | Azure location for Key Vault. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources Ids for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account | `number` | `30` | no |
| mysql\_options | List of configuration options: https://docs.microsoft.com/fr-fr/azure/mysql/howto-server-parameters#list-of-configurable-server-parameters | `list(map(string))` | `[]` | no |
| mysql\_version | Valid values are 5.6 and 5.7 | `string` | `"5.7"` | no |
| name\_prefix | Optional prefix for PostgreSQL server name | `string` | `""` | no |
| public\_network\_access\_enabled | Enable public network access for this server | `bool` | `true` | no |
| resource\_group\_name | Name of the application ressource group, herited from infra module | `string` | n/a | yes |
| stack | Name of application stack | `string` | n/a | yes |
| storage\_mb | Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 4194304 MB(4TB) for General Purpose/Memory Optimized SKUs. | `number` | `5120` | no |
| threat\_detection\_policy | Threat detection policy configuration, known in the API as Server Security Alerts Policy | `any` | `null` | no |
| tier | Tier for MySQL server sku: https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#tier<br>Possible values are: GeneralPurpose, Basic, MemoryOptimized. | `string` | `"GeneralPurpose"` | no |

## Outputs

| Name | Description |
|------|-------------|
| mysql\_administrator\_login | Administrator login for MySQL server |
| mysql\_configuration\_id | The list of all configurations resource ids |
| mysql\_database\_ids | The list of all database resource ids |
| mysql\_databases\_names | List of databases names |
| mysql\_databases\_users | List of usernames of created users corresponding to input databases names. |
| mysql\_databases\_users\_passwords | List of passwords of created users corresponding to input databases names. |
| mysql\_firewall\_rule\_ids | List of MySQL created rules |
| mysql\_fqdn | FQDN of the MySQL server |
| mysql\_server\_id | MySQL server ID |
| mysql\_server\_name | MySQL server name |
| mysql\_vnet\_rule\_ids | The list of all vnet rule resource ids |
<!-- END_TF_DOCS -->
## Related documentation

Microsoft Azure documentation: [docs.microsoft.com/fr-fr/azure/mysql/overview](https://docs.microsoft.com/fr-fr/azure/mysql/overview)
