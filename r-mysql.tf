resource "azurerm_mysql_server" "mysql_server" {
  name = coalesce(
    var.custom_server_name,
    "${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-mysql",
  )
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    capacity = lookup(var.server_sku, "capacity", null)
    family   = lookup(var.server_sku, "family", null)
    name     = lookup(var.server_sku, "name", null)
    tier     = lookup(var.server_sku, "tier", null)
  }
  storage_profile {
    backup_retention_days = lookup(var.server_storage_profile, "backup_retention_days", null)
    geo_redundant_backup  = lookup(var.server_storage_profile, "geo_redundant_backup", null)
    storage_mb            = lookup(var.server_storage_profile, "storage_mb", null)
  }

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_password
  version                      = var.mysql_version
  ssl_enforcement              = var.mysql_ssl_enforcement
  tags = merge(
    {
      "env"   = var.environment
      "stack" = var.stack
    },
    var.extra_tags,
  )
}

resource "azurerm_mysql_database" "mysql_db" {
  charset             = var.databases_charset[element(var.databases_names, count.index)]
  collation           = var.databases_collation[element(var.databases_names, count.index)]
  name                = element(var.databases_names, count.index)
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql_server.name
  count               = length(var.databases_names)
}

resource "azurerm_mysql_configuration" "config" {
  count               = length(var.mysql_options)
  name                = var.mysql_options[count.index].name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql_server.name
  value               = var.mysql_options[count.index].value
}