variable "mysql_ip" {
  type        = "list"
  default     = []
  description = "Value from webapp module"
}

variable "webapp_enabled" {
  default     = "false"
  description = "Enable/Disable webapp integration, used by access rules"
}

variable "length_webapp_ip" {
  type        = "string"
  default     = 0
  description = "Value used for access rules, the readme scenario must be followed"
}

variable "azure_region" {
  description = "Azure region in which the web app will be hosted"
}

variable "azure_region_short" {
  description = "Azure region trigram"
}

variable "environment" {
  description = "Name of application's environnement"
}

variable "stack" {
  description = "Name of application stack"
}

variable "client_name" {
  description = "Name of client"
}

variable "resource_group_name" {
  description = "Name of the application ressource group, herited from infra module"
}

variable "sql_user" {
  description = "Sql username"
}

variable "sql_pass" {
  description = "Strong Password : https://docs.microsoft.com/en-us/sql/relational-databases/security/strong-passwords?view=sql-server-2017"
}

variable "admin_cidrs" {
  description = "List of authorized cidrs, must be provided using remote states cloudpublic/cloudpublic/global/vars/terraform.state --> admin_cidrs"
}

variable "default_tags" {
  type        = "map"
  default     = {}
  description = "Map of tags, default not defined yet"
}

variable "custom_tags" {
  type        = "map"
  description = "Map of custom tags"
}

variable "server_sku" {
  type = "map"

  default = {
    name     = "B_Gen5_1"
    capacity = 1
    tier     = "Basic"
    family   = "Gen5"
  }

  description = "Server class : https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#sku"
}

variable "server_storage_profile" {
  type = "map"

  default = {
    storage_mb            = 5120
    backup_retention_days = 10
    geo_redundant_backup  = "Disabled"
  }

  description = "Storage configuration : https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#storage_profile"
}

variable "db_name" {
  description = "Name of database"
}

variable "mysql_options" {
  type        = "list"
  default     = []
  description = "List of configuration options : https://www.terraform.io/docs/providers/azurerm/r/mysql_configuration.html"
}

variable "mysql_version" {
  default     = "5.7"
  description = "Valid values are 5.6 and 5.7"
}

variable "mysql_ssl_enforcement" {
  default     = "Disabled"
  description = "Possible values are Enforced and Disabled"
}

variable "mysql_charset" {
  default     = "utf8"
  description = "Valid mysql charset : https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html"
}

variable "mysql_collation" {
  default     = "utf8_general_ci"
  description = "Valid mysql collation : https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html"
}