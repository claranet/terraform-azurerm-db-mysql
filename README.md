# Prerequisites
* module.infra.resource_group_name: "git::ssh://git@bitbucket.org/morea/terraform.feature.azurerm.basic.infra.git?ref=v1.0.0" 
* admin_cidrs variable from global remote states "cloudpublic/cloudpublic/global/vars/terraform.state" --> admin_cidrs


# Module declaration

Terraform module declaration example:

```
module "mysql" {
  source = "git::ssh://git@bitbucket.org/morea/terraform.feature.azure.mysql.git"
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
  db_name                = "${var.db_name}"

  mysql_name             = "cphu"
  mysql_options          = [{name = "interactive_timeout", value = "600" },{name = "wait_timeout", value = "260"}]
  mysql_version          = "${var.mysql_version}"
  mysql_ssl_enforcement  = "${var.mysql_ssl_enforcement}"
  mysql_charset          = "${var.mysql_charset}"
  mysql_collation        = "${var.mysql_collation}"

  default_tags = {
    environment = "${var.environment}"
    stack = "${var.stack}"
  }
  custom_tags    = "${var.custom_tags}"

# On first apply use the following, cause at this time module.webapps.app_service_outbound_ip_addresses output is not known
  admin_cidrs           = "${var.admin_cidrs}"

# Please apply again terraform by replacing admin_cidrs variable with following:
#  admin_cidrs           = "${concat(var.admin_cidrs, formatlist("%s/32", module.webapps.app_service_outbound_ip_addresses))}"
}

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| admin_cidrs | List of authorized cidrs, must be provided using remote states cloudpublic/cloudpublic/global/vars/terraform.state --> admin_cidrs | list | - | yes |
| azure_region | Azure region in which the web app will be hosted | string | - | yes |
| azure_region_short | Azure region trigram | string | - | yes |
| client_name | Name of client | string | - | yes |
| custom_tags | Map of custom tags | map | - | yes |
| db_name | Name of database | string | - | yes |
| default_tags | Map of tags, default not defined yet | map | `<map>` | no |
| environment | Name of application's environnement | string | - | yes |
| length_webapp_ip | Value used for access rules, the readme scenario must be followed | string | `0` | no |
| mysql_charset | Valid mysql charset : https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html | string | `utf8` | no |
| mysql_collation | Valid mysql collation : https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html | string | `utf8_general_ci` | no |
| mysql_webapp_ip | Value from webapp module | list | `<list>` | no |
| mysql_name | Name identifier | string | - | yes |
| mysql_options | List of configuration options : https://docs.microsoft.com/fr-fr/azure/mysql/howto-server-parameters#list-of-configurable-server-parameters | list | `<list>` | no |
| mysql_ssl_enforcement | Possible values are Enforced and Disabled | string | `Disabled` | no |
| mysql_version | Valid values are 5.6 and 5.7 | string | `5.7` | no |
| resource_group_name | Name of the application ressource group, herited from infra module | string | - | yes |
| server_sku | Server class : https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#sku | map | `<map>` | no |
| server_storage_profile | Storage configuration : https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#storage_profile | map | `<map>` | no |
| sql_pass | Strong Password : https://docs.microsoft.com/en-us/sql/relational-databases/security/strong-passwords?view=sql-server-2017 | string | - | yes |
| sql_user | Sql username | string | - | yes |
| stack | Name of application stack | string | - | yes |
| webapp_enabled | Enable/Disable webapp integration, used by access rules | string | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| azure_mysql_db_name | Database Name |
| azure_mysql_firewall_rule_id | List of mysql created rules |
| azure_mysql_fqdn | Mysql generated fqdn |
| azure_mysql_id | Mysql instance id |
| azure_mysql_login | Username |
| azure_mysql_password | Password |

