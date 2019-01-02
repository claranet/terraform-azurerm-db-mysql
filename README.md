# Prerequisites
* module.infra.resource_group_name: `git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/rg.git?ref=v0.1.0`
* admin_cidrs variable from global remote states "cloudpublic/cloudpublic/global/vars/terraform.state" --> admin_cidrs
* module.az-region.location|location-short: `git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/regions.git?ref=v1.0.0`

## Optional

if `webapp_enabled = true`

You should have a dependency with:

module.webapps.outbound_ip_addresses: `git::ssh://git@git.fr.clara.net:claranet/cloudnative/projects/cloud/azure/terraform/features/app-service-web.git`

Prior to terraform 0.12, it was not possible to use a count on computed value, in our case count = "${length(module.webapps.outbound_ip_addresses}"
So we have to add some manualy steps, described below:

To use webapps you have to :

* Add in module declaration:

```
module "mysql" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/features/db-mysql.git"
  ...
     client_name            = "${var.client_name}"
     azure_region           = "${module.az-region.location}"
-->  mysql_webapp_ip        = "${module.webapps.app_service_outbound_ip_addresses}"
-->  webapp_enabled         = "true"
  ...
```
* Apply terraform and identify the number of ip your webapp have (throught webapp properties or using a dedicated output in your stack) 

* Change following variable 

```
--> length_webapp_ip        = "XXXX" (at first apply it will takes the default value "0")

```

* Apply terraform 

# Module declaration

Terraform module declaration example:

```
module "mysql" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/features/db-mysql.git"
  client_name            = "${var.client_name}"
  azure_region           = "${module.az-region.location}"
  azure_region_short     = "${module.az-region.location-short}"
  environment            = "${var.environment}"
  stack                  = "${var.stack}"

  server_sku             = "${var.mysql_server_sku}"
  server_storage_profile = "${var.mysql_server_storage_profile}"
  resource_group_name  = "${module.infra.resource_group_name}"

  sql_user               = "${var.sql_user}"
  sql_pass               = "${var.sql_pass}"
  db_names               = "${var.db_names}"

  mysql_name             = "${var.sql_name}"
  mysql_options          = "${var.mysql_options}" ==> Example:  [{name = "interactive_timeout", value = "600" },{name = "wait_timeout", value = "260"}]
  mysql_version          = "${var.mysql_version}"
  mysql_ssl_enforcement  = "${var.mysql_ssl_enforcement}"
  db_charset             = "${var.db_charset}"
  db_collation           = "${var.db_collation}"

  custom_tags    = "${var.custom_tags}"

If we need to link to a webapp
  webapp_enabled         = "true"
  mysql_webapp_ip        = "${module.webapps.app_service_outbound_ip_addresses}"
  length_webapp_ip       = "XXX" ===> Value must be given manually after the first apply, see Readme
}

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| azure_region | Azure region in which the web app will be hosted | string | - | yes |
| azure_region_short | Azure region trigram | string | - | yes |
| client_name | Name of client | string | - | yes |
| environment | Name of application's environnement | string | - | yes |
| resource_group_name | Name of the application ressource group, herited from infra module | string | - | yes |
| stack | Name of application stack | string | - | yes |
| db_names | Name of database | string | - | yes |
| db_charset | Valid mysql charset : https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html | string | `utf8` | no |
| db_collation | Valid mysql collation : https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html | string | `utf8_general_ci` | no |
| mysql_name | Name identifier | string | - | yes |
| mysql_options | List of configuration options : https://docs.microsoft.com/fr-fr/azure/mysql/howto-server-parameters#list-of-configurable-server-parameters | list | `<list>` | no |
| mysql_ssl_enforcement | Possible values are Enforced and Disabled | string | `Disabled` | no |
| mysql_version | Valid values are 5.6 and 5.7 | string | `5.7` | no |
| mysql_webapp_ip | Value from webapp module | list | `<list>` | no |
| server_sku | Server class : https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#sku | map | `<map>` | no |
| server_storage_profile | Storage configuration : https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#storage_profile | map | `<map>` | no |
| sql_pass | Strong Password : https://docs.microsoft.com/en-us/sql/relational-databases/security/strong-passwords?view=sql-server-2017 | string | - | yes |
| sql_user | Sql username | string | - | yes |
| admin_cidrs | List of authorized cidrs, must be provided using remote states cloudpublic/cloudpublic/global/vars/terraform.state --> admin_cidrs | list | - | yes |
| custom_tags | Map of custom tags | map | - | yes |
| length_webapp_ip | Value used for access rules, the readme scenario must be followed | string | `0` | no |
| webapp_enabled | Enable/Disable webapp integration, used by access rules | string | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| azure_mysql_db_name | List of Databases Names |
| azure_mysql_firewall_rule_ids | List of mysql created rules |
| azure_mysql_fqdn | Mysql generated fqdn |
| azure_mysql_id | Mysql instance id |
| azure_mysql_login | Username |

