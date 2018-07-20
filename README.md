# Prerequisites
module.infra.resource_group_name: "git::ssh://git@bitbucket.org/morea/terraform.feature.azurerm.basic.infra.git?ref=v1.0.0" 


## Optional
if **'webapp_enabled'** = true

module.webapps.outbound_ip_addresses: "git::ssh://git@bitbucket.org/morea/terraform.feature.azure.webapps.git"

To use webapp you have to :
1. add in module declaration:
```
module "mysql" {
  source = "git::ssh://git@bitbucket.org/morea/terraform.feature.azure.mysql.git"
  ...
     client_name            = "${var.client_name}"
     azure_region           = "${module.az-region.location}"
     number_rules           = "${length(var.admin_cidrs)}"
-->  mysql_ip               = "${module.webapps.app_service_outbound_ip_addresses}"
-->  webapp_enabled         = "true"
  ...
```
2. enable remote states (remote-states.tf)
```
data "terraform_remote_state" "azure" {
  backend = "s3"

  config {
    bucket = "s3-terraform-states-eu-west-1-612688033368"
    key    = "claranet/claranet/AzureCloud/fr-central/cphu/terraform.state"
    region = "eu-west-1"
  }
}
```
3. apply terraform to initialize azure.webapp_lenght_ip in remote state

4. change following variable
```
--> length_webapp_ip         = "${data.terraform_remote_state.azure.webapp_lenght_ip}"
```
5. apply terraform 

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
  sql_user               = "${var.sql_user}"
  sql_pass               = "${var.sql_pass}"
  db_name                = "${var.db_name}"
  mysql_options          = "${var.mysql_options}"
  mysql_version          = "${var.mysql_version}"
  mysql_ssl_enforcement  = "${var.mysql_ssl_enforcement}"
  mysql_charset          = "${var.mysql_charset}"
  mysql_collation        = "${var.mysql_collation}"
  default_tags           = {environment = "${var.environment}", stack= "${var.stack}"}
  authorized_cidr_list     = "${var.admin_cidrs}"
  resource_group_name      = "${module.infra.resource_group_name}"
  number_rules             = "${length(var.admin_cidrs)}"
  custom_tags              = "${var.custom_tags}"
If we need to link to a webapp
  webapp_enabled           = "false"
  mysql_ip                 = "${module.webapps.app_service_outbound_ip_addresses}"
  length_webapp_ip         = "${data.terraform_remote_state.azure.webapp_lenght_ip}"
}
```

# Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| admin_cidrs |  | list | `<list>` | no |
| authorized_cidr_list |  | list | - | yes |
| azure_region |  | string | - | yes |
| azure_region_short |  | string | - | yes |
| client_name |  | string | - | yes |
| custom_tags |  | map | - | yes |
| db_name |  | string | - | yes |
| default_tags |  | map | `<map>` | no |
| environment |  | string | - | yes |
| length_webapp_ip |  | string | `0` | no |
| mysql_charset |  | string | `utf8` | no |
| mysql_collation |  | string | `utf8_general_ci` | no |
| mysql_ip |  | list | - | yes |
| mysql_options |  | list | `<list>` | no |
| mysql_server_sku |  | map | `<map>` | no |
| mysql_server_storage_profile |  | map | `<map>` | no |
| mysql_ssl_enforcement |  | string | `Disabled` | no |
| mysql_version |  | string | `5.7` | no |
| number_rules |  | string | - | yes |
| resource_group_name |  | string | - | yes |
| server_sku |  | map | - | yes |
| server_storage_profile |  | map | - | yes |
| sql_pass |  | string | - | yes |
| sql_user |  | string | - | yes |
| stack |  | string | - | yes |
| webapp_enabled |  | string | `false` | no |

# Outputs

| Name | Description |
|------|-------------|
| azure_mysql_db_name |  |
| azure_mysql_firewall_rule_id |  |
| azure_mysql_fqdn |  |
| azure_mysql_id |  |
| azure_mysql_login |  |
| azure_mysql_password |  |

