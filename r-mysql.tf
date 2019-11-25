resource "azurerm_mysql_server" "mysql_server" {
  name = coalesce(
    var.custom_server_name,
    local.default_name_server,
  )

  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = join("_", [lookup(local.tier_map, var.tier, "GeneralPurpose"), "Gen5", var.capacity])
    capacity = var.capacity
    tier     = var.tier
    family   = "Gen5"
  }

  storage_profile {
    backup_retention_days = lookup(var.server_storage_profile, "backup_retention_days", null)
    geo_redundant_backup  = lookup(var.server_storage_profile, "geo_redundant_backup", null)
    storage_mb            = lookup(var.server_storage_profile, "storage_mb", null)
  }

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_password
  version                      = var.mysql_version
  ssl_enforcement              = var.force_ssl ? "Enabled" : "Disabled"


  tags = merge(local.default_tags, var.extra_tags)
}

resource "azurerm_mysql_database" "mysql_db" {
  count               = length(var.databases_names)
  charset             = lookup(var.databases_charset, element(var.databases_names, count.index), "utf8")
  collation           = lookup(var.databases_collation, element(var.databases_names, count.index), "utf8_general_ci")
  name                = element(var.databases_names, count.index)
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql_server.name
}

resource "azurerm_mysql_configuration" "mysql_config" {
  count = length(var.mysql_options)

  name                = var.mysql_options[count.index].name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql_server.name
  value               = var.mysql_options[count.index].value
}
