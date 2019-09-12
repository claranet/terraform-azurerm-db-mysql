variable "custom_server_name" {
  type        = string
  description = "Custom Server Name identifier"
  default     = ""
}

variable "location" {
  description = "Azure region in which the web app will be hosted"
}

variable "location_short" {
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

variable "administrator_login" {
  description = "MySQL administrator login"
}

variable "administrator_password" {
  description = "MySQL administrator password. Strong Password : https://docs.microsoft.com/en-us/sql/relational-databases/security/strong-passwords?view=sql-server-2017"
}

variable "allowed_ip_addresses" {
  type        = list(string)
  description = "List of authorized cidrs, must be provided using remote states cloudpublic/cloudpublic/global/vars/terraform.state"
}

variable "extra_tags" {
  type        = map(string)
  description = "Map of custom tags"
}

variable "server_sku" {
  type = map(string)

  default = {
    name     = "B_Gen5_1"
    capacity = 1
    tier     = "Basic"
    family   = "Gen5"
  }

  description = "Server class : https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#sku"
}

variable "server_storage_profile" {
  type = map(string)

  default = {
    storage_mb            = 5120
    backup_retention_days = 10
    geo_redundant_backup  = "Disabled"
  }

  description = "Storage configuration : https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#storage_profile"
}

variable "databases_names" {
  description = "List of databases names"
  type        = list(string)
}

variable "mysql_options" {
  type        = list(map(string))
  default     = []
  description = "List of configuration options : https://docs.microsoft.com/fr-fr/azure/mysql/howto-server-parameters#list-of-configurable-server-parameters"
}

variable "mysql_version" {
  default     = "5.7"
  description = "Valid values are 5.6 and 5.7"
}

variable "mysql_ssl_enforcement" {
  default     = "Disabled"
  description = "Possible values are Enforced and Disabled"
}

variable "databases_charset" {
  type        = map(string)
  description = "Valid mysql charset : https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html"

  default = {
    "test" = "utf8"
  }
}

variable "databases_collation" {
  type        = map(string)
  description = "Valid mysql collation : https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html"

  default = {
    "test" = "utf8_general_ci"
  }
}

variable "enable_logs_to_storage" {
  description = "Boolean flag to specify whether the logs should be sent to the Storage Account"
  type        = string
  default     = "false"
}

variable "enable_logs_to_log_analytics" {
  description = "Boolean flag to specify whether the logs should be sent to Log Analytics"
  type        = string
  default     = "false"
}

variable "logs_storage_retention" {
  description = "Retention in days for logs on Storage Account"
  type        = string
  default     = "30"
}

variable "logs_storage_account_id" {
  description = "Storage Account id for logs"
  type        = string
  default     = ""
}

variable "logs_log_analytics_workspace_id" {
  description = "Log Analytics Workspace id for logs"
  type        = string
  default     = ""
}

