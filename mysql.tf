resource "azurerm_mysql_server" "mysql_server" {
  name                         = "${coalesce(var.server_name, "mysql-${var.environment}-${var.location_short}-${var.client_name}-${var.stack}-${var.mysql_name}")}"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  sku                          = ["${var.server_sku}"]
  storage_profile              = ["${var.server_storage_profile}"]
  administrator_login          = "${var.sql_user}"
  administrator_login_password = "${var.sql_pass}"
  version                      = "${var.mysql_version}"
  ssl_enforcement              = "${var.mysql_ssl_enforcement}"
  tags                         = "${merge(map("env", var.environment, "stack", var.stack), var.extra_tags)}"
}

resource "azurerm_mysql_database" "mysql_db" {
  charset             = "${lookup(var.db_charset, (element(var.db_names, count.index)))}"
  collation           = "${lookup(var.db_collation, (element(var.db_names, count.index)))}"
  name                = "${element(var.db_names, count.index)}"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_mysql_server.mysql_server.name}"
  count               = "${length(var.db_names)}"
}

resource "azurerm_mysql_configuration" "config" {
  count               = "${length(var.mysql_options)}"
  name                = "${lookup(var.mysql_options[count.index], "name")}"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_mysql_server.mysql_server.name}"
  value               = "${lookup(var.mysql_options[count.index], "value")}"
}
