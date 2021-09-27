resource "azurerm_mysql_server" "mysql_server" {
  name = local.mysql_server_name

  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = join("_", [lookup(local.tier_map, var.tier, "GeneralPurpose"), "Gen5", var.capacity])

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  storage_mb                   = var.storage_mb
  auto_grow_enabled            = var.auto_grow_enabled

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_password
  version                      = var.mysql_version
  ssl_enforcement_enabled      = var.force_ssl

  public_network_access_enabled = var.public_network_access_enabled

  dynamic "threat_detection_policy" {
    for_each = var.threat_detection_policy != null ? [var.threat_detection_policy] : []
    content {
      enabled                    = lookup(threat_detection_policy.value, "enabled", false)
      disabled_alerts            = lookup(threat_detection_policy.value, "disabled_alerts", [])
      email_account_admins       = lookup(threat_detection_policy.value, "email_account_admins", false)
      email_addresses            = lookup(threat_detection_policy.value, "email_addresses", [])
      retention_days             = lookup(threat_detection_policy.value, "retention_days", 0)
      storage_account_access_key = lookup(threat_detection_policy.value, "storage_account_access_key", null)
      storage_endpoint           = lookup(threat_detection_policy.value, "storage_endpoint", null)
    }
  }

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
