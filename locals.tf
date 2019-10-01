locals {
  name_prefix = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""

  default_name_server = "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-mysql"

  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  administrator_login = format("%s@%s", azurerm_mysql_server.mysql_server.administrator_login, azurerm_mysql_server.mysql_server.name)
  db_users_login      = formatlist("%s@%s", mysql_user.users.*.user, azurerm_mysql_server.mysql_server.name)

  tier_map = {
    "GeneralPurpose"  = "GP"
    "Basic"           = "B"
    "MemoryOptimized" = "MO"
  }
}
