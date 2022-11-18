data "azurecaf_name" "mysql" {
  name          = var.stack
  resource_type = "azurerm_mysql_server"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "mysql"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "mysql_dbs" {
  for_each = var.databases

  name          = var.stack
  resource_type = "azurerm_mysql_database"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, each.key, var.use_caf_naming ? "" : "mysql"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}
