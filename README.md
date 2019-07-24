# Azure Managed Mysql Service 

Create and manage mysql service (server, databases, firewall rules) 

# Requirements
* Azure provider >= 1.31
* Terraform >=0.12

## Prerequisites
* module.infra.resource_group_name: `git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/rg.git?ref=vX.X.X`
* allowed_ip_addresses variable from global remote states "cloudpublic/cloudpublic/global/vars/terraform.state" --> allowed_ip_addresses
* module.az-region.location|location_short: `git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/regions.git?ref=vX.X.X`

## Usage
You can use this module by including it this way:
```hcl
module "az-region" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/regions.git?ref=vX.X.X"

  azure_region = var.azure_region
}

module "rg" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/rg.git?ref=vX.X.X"

  location    = module.az-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "mysql" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/features/db-mysql.git?ref=vX.X.X."
  
  client_name          = var.client_name
  environment          = var.environment
  location             = module.az-region.location
  location_short       = module.az-region.location_short
  resource_group_name  = module.rg.resource_group_name
  stack                = var.stack

  server_sku             = var.mysql_server_sku
  server_storage_profile = var.mysql_server_storage_profile

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  databases_names        = var.databases_names

  mysql_options         = [{name="interactive_timeout", value="600"}, {name="wait_timeout", value="260"}]
  mysql_version         = var.mysql_version
  mysql_ssl_enforcement = var.mysql_ssl_enforcement
  databases_charset     = var.databases_charset
  databases_collation   = var.databases_collation

  extra_tags = var.extra_tags
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| administrator_login | MySQL administrator login | string | - | yes |
| administrator_password | MySQL administrator password. Strong Password : https://docs.microsoft.com/en-us/sql/relational-databases/security/strong-passwords?view=sql-server-2017 | string | - | yes |
| allowed_ip_addresses | List of authorized cidrs, must be provided using remote states cloudpublic/cloudpublic/global/vars/terraform.state | list | - | yes |
| client_name | Name of client | string | - | yes |
| custom_server_name | Custom Server Name identifier | string | `` | no |
| databases_charset | Valid mysql charset : https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html | map | `<map>` | no |
| databases_collation | Valid mysql collation : https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html | map | `<map>` | no |
| databases_names | List of databases names | list | `<list>` | no |
| environment | Name of application's environnement | string | - | yes |
| extra_tags | Map of custom tags | map | - | yes |
| location | Azure region in which the web app will be hosted | string | - | yes |
| location_short | Azure region trigram | string | - | yes |
| mysql_options | List of configuration options : https://docs.microsoft.com/fr-fr/azure/mysql/howto-server-parameters#list-of-configurable-server-parameters | list | `<list>` | no |
| mysql_ssl_enforcement | Possible values are Enforced and Disabled | string | `Disabled` | no |
| mysql_version | Valid values are 5.6 and 5.7 | string | `5.7` | no |
| resource_group_name | Name of the application ressource group, herited from infra module | string | - | yes |
| server_sku | Server class : https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#sku | map | `<map>` | no |
| server_storage_profile | Storage configuration : https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#storage_profile | map | `<map>` | no |
| stack | Name of application stack | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| mysql_administrator_login | Administrator login for MySQL server |
| mysql_databases_names | List of databases names |
| mysql_firewall_rule_ids | List of MySQL created rules |
| mysql_fqdn | FQDN of the MySQL server |
| mysql_server_id | MySQL server ID |
