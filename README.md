 Prerequisites
* module.infra.resource_group_name: `git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/rg.git?ref=v0.1.0`
* allowed_ip_addressess variable from global remote states "cloudpublic/cloudpublic/global/vars/terraform.state" --> allowed_ip_addressess
* module.az-region.location|location-short: `git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/regions.git?ref=v1.0.0`

# Module declaration

shell module declaration example:

```shell
module "az-region" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/regions.git?ref=vX.X.X"

  azure_region = "${var.azure_region}"
}

module "rg" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/rg.git?ref=vX.X.X"

  azure_region = "${module.az-region.location}"
  client_name  = "${var.client_name}"
  environment  = "${var.environment}"
  stack        = "${var.stack}"
}

module "mysql" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/features/db-mysql.git"

  mysql_name or server_name = "${var.mysql_name or var.server_name}" 

#mysql_name is used to have a personalized name
#server_name will be used as follow: `mysql-${var.environment}-${var.location_short}-${var.client_name}-${var.stack}-${var.server_name}`

  client_name               = "${var.client_name}"
  location                  = "${module.az-region.location}"
  location_short            = "${module.az-region.location-short}"
  environment               = "${var.environment}"
  stack                     = "${var.stack}"

  server_sku                = "${var.mysql_server_sku}"
  server_storage_profile    = "${var.mysql_server_storage_profile}"
  resource_group_name       = "${module.rg.resource_group_name}"

  sql_user                  = "${var.sql_user}"
  sql_pass                  = "${var.sql_pass}"
  db_names                  = "${var.db_names}"

  mysql_name                = "${var.sql_name}"
  mysql_options             = "${var.mysql_options}" ==> Example:  [{name = "interactive_timeout", value = "600" },{name = "wait_timeout", value = "260"}]
  mysql_version             = "${var.mysql_version}"
  mysql_ssl_enforcement     = "${var.mysql_ssl_enforcement}"
  db_charset                = "${var.db_charset}"
  db_collation              = "${var.db_collation}"

  extra_tags                = "${var.extra_tags}"

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allowed_ip_addressess | List of authorized cidrs, must be provided using remote states cloudpublic/cloudpublic/global/vars/terraform.state | list | - | yes |
| client_name | Name of client | string | - | yes |
| db_charset | Valid mysql charset : https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html | map | `<map>` | no |
| db_collation | Valid mysql collation : https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html | map | `<map>` | no |
| db_names | List of databases names | list | `<list>` | no |
| environment | Name of application's environnement | string | - | yes |
| extra_tags | Map of custom tags | map | - | yes |
| location | Azure region in which the web app will be hosted | string | - | yes |
| location_short | Azure region trigram | string | - | yes |
| mysql_name | Name identifier | string | `test` | no |
| mysql_options | List of configuration options : https://docs.microsoft.com/fr-fr/azure/mysql/howto-server-parameters#list-of-configurable-server-parameters | list | `<list>` | no |
| mysql_ssl_enforcement | Possible values are Enforced and Disabled | string | `Disabled` | no |
| mysql_version | Valid values are 5.6 and 5.7 | string | `5.7` | no |
| resource_group_name | Name of the application ressource group, herited from infra module | string | - | yes |
| server_name | Custom Name identifier | string | - | yes |
| server_sku | Server class : https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#sku | map | `<map>` | no |
| server_storage_profile | Storage configuration : https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#storage_profile | map | `<map>` | no |
| sql_pass | Strong Password : https://docs.microsoft.com/en-us/sql/relational-databases/security/strong-passwords?view=sql-server-2017 | string | - | yes |
| sql_user | Sql username | string | - | yes |
| stack | Name of application stack | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| azure_mysql_db_names | List of database names |
| azure_mysql_firewall_rule_ids | List of mysql created rules |
| azure_mysql_fqdn | Mysql generated fqdn |
| azure_mysql_id | Mysql instance id |
| azure_mysql_login | Username |
