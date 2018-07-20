variable "webapp_enabled" {
  default = "false"
}
variable "length_webapp_ip" {
  type = "string"
  default = 0
}
variable "mysql_ip" {
  type = "list"
}
variable "number_rules" {
  type = "string"
}

variable "azure_region" {}
#variable "ssl_enforcement" {}

variable "azure_region_short" {}

variable "environment" {}

variable "stack" {}

variable "client_name" {}

variable "resource_group_name" {}

variable "sql_user" {}

variable "sql_pass" {}

variable "admin_cidrs" {
  type = "list"
  default = [
    "62.240.254.6/32",  # VPN Claranet
    "185.88.104.16/32", # VPN Claranet
    "31.3.136.12/32",   # VPN Claranet Cloudpractice
    "62.240.254.57/30", # Claranet Rennes
  ]
  }

variable "mysql_server_sku" {
    type  = "map"

    default = {
    name     = "B_Gen5_1"
    capacity = 1
    tier     = "Basic"
    family   = "Gen5"
    }
  }

variable "mysql_server_storage_profile" {
    type = "map" 

    default = {
    storage_mb = 5120
    backup_retention_days = 10
    geo_redundant_backup  = "Disabled"
    }
  }

variable  "default_tags" {
    type = "map"
    default = {}
}

variable  "custom_tags" {
    type = "map"
}

variable "server_sku" {
  type = "map"
}

variable "server_storage_profile" {
  type = "map"
}

variable "authorized_cidr_list" {
  type = "list"
}

variable "db_name" {}

variable "mysql_options" {
  type    = "list"
  default = []
}

variable "mysql_version" {
  default = "5.7"
}

variable "mysql_ssl_enforcement" {
  default = "Disabled"
}

variable "mysql_charset" {
  default = "utf8"
}

variable "mysql_collation" {
  default = "utf8_general_ci"
}
