variable "client_name" {
  description = "Name of client"
  type        = string
}

variable "environment" {
  description = "Name of application's environnement"
  type        = string
}

variable "stack" {
  description = "Name of application stack"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the application ressource group, herited from infra module"
  type        = string
}

variable "location" {
  description = "Azure location for Key Vault."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "name_prefix" {
  description = "Optional prefix for PostgreSQL server name"
  type        = string
  default     = ""
}

variable "custom_server_name" {
  type        = string
  description = "Custom Server Name identifier"
  default     = ""
}

variable "administrator_login" {
  description = "MySQL administrator login"
  type        = string
}

variable "administrator_password" {
  description = "MySQL administrator password. Strong Password : https://docs.microsoft.com/en-us/sql/relational-databases/security/strong-passwords?view=sql-server-2017"
  type        = string
}

variable "allowed_cidrs" {
  type        = list(string)
  description = "List of authorized cidrs"
}

variable "extra_tags" {
  type        = map(string)
  description = "Map of custom tags"
  default     = {}
}

variable "tier" {
  type        = string
  description = "Tier for MySQL server sku : https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#tier Possible values are: GeneralPurpose, Basic, MemoryOptimized"
  default     = "GeneralPurpose"
}

variable "capacity" {
  type        = number
  description = "Capacity for MySQL server sku : https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#capacity"
  default     = 4
}

variable "server_storage_profile" {
  type = map(string)

  default = {
    storage_mb            = 5120
    backup_retention_days = 10
    geo_redundant_backup  = "Enabled"
  }

  description = "Storage configuration : https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#storage_profile"
}

variable "mysql_options" {
  type        = list(map(string))
  default     = []
  description = "List of configuration options : https://docs.microsoft.com/fr-fr/azure/mysql/howto-server-parameters#list-of-configurable-server-parameters"
}

variable "mysql_version" {
  type        = string
  default     = "5.7"
  description = "Valid values are 5.6 and 5.7"
}

variable "force_ssl" {
  type        = bool
  default     = true
  description = "Force usage of SSL"
}

variable "vnet_rules" {
  type        = list(map(string))
  description = "List of vnet rules to create"
  default     = []
}

variable "databases_names" {
  description = "List of databases names"
  type        = list(string)
}

variable "databases_charset" {
  type        = map(string)
  description = "Valid mysql charset : https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html"
  default     = {}
}

variable "databases_collation" {
  type        = map(string)
  description = "Valid mysql collation : https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html"
  default     = {}
}

variable "enable_logs_to_storage" {
  description = "Boolean flag to specify whether the logs should be sent to the Storage Account"
  type        = bool
  default     = false
}

variable "enable_logs_to_log_analytics" {
  description = "Boolean flag to specify whether the logs should be sent to Log Analytics"
  type        = bool
  default     = false
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

variable "create_databases_users" {
  description = "True to create a user named <db>_user per database with generated password."
  type        = string
  default     = "true"
}
