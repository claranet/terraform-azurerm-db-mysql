resource "azurerm_mysql_firewall_rule" "mysql_rule" {
  name                = "mysql-rule-${replace(cidrhost(element(var.admin_cidrs, count.index), 0),".","-")}"
  count               = "${length(var.admin_cidrs)}"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_mysql_server.mysql_server.name}"
  start_ip_address    = "${cidrhost(element(var.admin_cidrs, count.index), 0)}"
  end_ip_address      = "${cidrhost(element(var.admin_cidrs, count.index), -1)}"
}

resource "azurerm_mysql_firewall_rule" "webapp_rule" {
  count               = "${var.webapp_enabled == "true" ?  var.length_webapp_ip : 0 }"
  name                = "mysql-rule-webapp-${replace(element(var.mysql_ip, count.index),".","-")}"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_mysql_server.mysql_server.name}"
  start_ip_address    = "${element(var.mysql_ip, count.index)}"
  end_ip_address      = "${element(var.mysql_ip, count.index)}"
}
