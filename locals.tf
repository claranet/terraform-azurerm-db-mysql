locals {
  name_prefix  = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""
  default_name = lower("${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}")

  mysql_server_name = coalesce(var.custom_server_name, "${local.default_name}-mysql")

  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  administrator_login    = format("%s@%s", azurerm_mysql_server.mysql_server.administrator_login, azurerm_mysql_server.mysql_server.name)
  administrator_password = coalesce(var.administrator_password, random_password.mysql_administrator_password.result)

  user_suffix = var.user_suffix != null ? var.user_suffix : ""

  tier_map = {
    "GeneralPurpose"  = "GP"
    "Basic"           = "B"
    "MemoryOptimized" = "MO"
  }

  default_mysql_options = {
    log_bin_trust_function_creators = "ON",
    connect_timeout                 = 60,
    interactive_timeout             = 28800,
    wait_timeout                    = 28800
  }

  mysql_options = merge(local.default_mysql_options, var.mysql_options)
}
