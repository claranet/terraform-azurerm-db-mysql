resource "azurerm_mysql_server" "mysql_server" {
  name                         = "mysql-${var.environment}-${var.azure_region_short}-${var.client_name}-${var.stack}"
  location                     = "${var.azure_region}"
  resource_group_name          = "${var.resource_group_name}"
  sku                          = ["${var.server_sku}"]
  storage_profile              = ["${var.server_storage_profile}"]
  administrator_login          = "${var.sql_user}"
  administrator_login_password = "${var.sql_pass}"
  version                      = "${var.mysql_version}"
  ssl_enforcement              = "${var.mysql_ssl_enforcement}"
  tags                         = "${merge(var.default_tags, var.custom_tags)}"
}

resource "azurerm_mysql_database" "mysql_db" {
  charset             = "${var.mysql_charset}"
  collation           = "${var.mysql_collation}"
  name                = "${var.db_name}"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_mysql_server.mysql_server.name}"
}

resource "azurerm_mysql_configuration" "config" {
  count               = "${length(var.mysql_options)}"
  name                = "${lookup(element(var.mysql_options, count.index), "name")}"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_mysql_server.mysql_server.name}"
  value               = "${lookup(element(var.mysql_options, count.index), "value")}"
}
