variable "location" {
  description = "Azure location."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "stack" {
  description = "Project stack name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "administrator_login" {
  description = "MySQL administrator login"
  type        = string
}

variable "administrator_password" {
  description = "MySQL administrator password. If not set, randomly generated"
  type        = string
  default     = ""
}

variable "allowed_cidrs" {
  type        = map(string)
  description = "Map of authorized cidrs"
}

variable "allowed_subnets" {
  type        = map(string)
  description = "Map of authorized subnet ids"
  default     = {}
}

variable "tier" {
  type        = string
  description = <<DESC
Tier for MySQL server sku: https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#tier
Possible values are: GeneralPurpose, Basic, MemoryOptimized.
DESC
  default     = "GeneralPurpose"
}

variable "capacity" {
  type        = number
  description = "Capacity for MySQL server sku: https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#capacity"
  default     = 4
}

variable "auto_grow_enabled" {
  description = "Enable/Disable auto-growing of the storage."
  type        = bool
  default     = false
}

variable "storage_mb" {
  description = "Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 4194304 MB(4TB) for General Purpose/Memory Optimized SKUs."
  type        = number
  default     = 5120
}

variable "backup_retention_days" {
  description = "Backup retention days for the server, supported values are between 7 and 35 days."
  type        = number
  default     = 10
}

variable "geo_redundant_backup_enabled" {
  description = "Turn Geo-redundant server backups on/off. Not available for the Basic tier."
  type        = bool
  default     = true
}

variable "mysql_options" {
  description = <<EOF
    Map of configuration options: https://docs.microsoft.com/fr-fr/azure/mysql/howto-server-parameters#list-of-configurable-server-parameters. Merged with default_mysql_options local:
    ```
    log_bin_trust_function_creators = "ON"
    connect_timeout                 = 60
    interactive_timeout             = 28800
    wait_timeout                    = 28800
    ```
  EOF
  type        = map(string)
  default     = {}
}

variable "mysql_version" {
  description = "Valid values are 5.6, 5.7 and 8.0"
  type        = string
  default     = "5.7"
}

variable "force_ssl" {
  description = "Enforce SSL connection"
  type        = bool
  default     = true
}

variable "databases" {
  description = "Map of databases with default collation and charset"
  type        = map(map(string))
}

variable "create_databases_users" {
  description = "True to create a user named <db>(_user) per database with generated password."
  type        = bool
  default     = true
}

variable "user_suffix" {
  description = "Suffix to append to the created users"
  type        = string
  default     = "_user"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Enable public network access for this server"
  default     = true
}

variable "threat_detection_policy" {
  type        = any
  description = "Threat detection policy configuration, known in the API as Server Security Alerts Policy"
  default     = null
}
