module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
}

module "mysql" {
  source  = "claranet/db-mysql/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  tier     = "GeneralPurpose"
  capacity = 4

  allowed_cidrs = {
    peered-vnet     = "10.0.0.0/24",
    customer-office = "12.34.56.78/32"
  }

  storage_mb                   = 5120
  backup_retention_days        = 10
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = false

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  databases = {
    "documents" = {
      "charset"   = "utf8"
      "collation" = "utf8_general_ci"
    }
  }

  force_ssl = true
  mysql_options = {
    interactive_timeout = "600",
    wait_timeout        = "260"
  }
  mysql_version = "5.7"

  threat_detection_policy = {
    email_addresses = ["john@doe.com"]
  }

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id
  ]

  extra_tags = {
    foo = "bar"
  }
}

provider "mysql" {
  endpoint = format("%s:3306", module.mysql.mysql_fqdn)
  username = format("%s@%s", var.administrator_login, module.mysql.mysql_server_name)
  password = var.administrator_password

  tls = true
}

module "mysql_users" {
  source = "git::ssh://git@git.fr.clara.net/claranet/projects/cloud/azure/terraform/mysql-users.git?ref=AZ-762_init_mysql_users"

  for_each = toset(module.mysql.mysql_databases_names)

  user_suffix_enabled = true
  user                = each.key
  database            = each.key
}
