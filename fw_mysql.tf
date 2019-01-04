resource "azurerm_mysql_firewall_rule" "mysql_rule" {
  name                = "mysql-rule-${replace(cidrhost(element(var.allowed_ip_addressess, count.index), 0),".","-")}"
  count               = "${length(var.allowed_ip_addressess)}"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_mysql_server.mysql_server.name}"
  start_ip_address    = "${cidrhost(element(var.allowed_ip_addressess, count.index), 0)}"
  end_ip_address      = "${cidrhost(element(var.allowed_ip_addressess, count.index), -1)}"
}

resource "azurerm_mysql_firewall_rule" "webapp_rule" {
  count = "${var.webapp_enabled == "1" ?  var.length_webapp_ip : 0}"

  # count must be done on module.webapps.app_service_outbound_ip_addresses, but until terraform 0.12, it is not possible (count on computed value)
  name                = "mysql-rule-webapp-${replace(element(var.mysql_webapp_ip, count.index),".","-")}"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_mysql_server.mysql_server.name}"
  start_ip_address    = "${element(var.mysql_webapp_ip, count.index)}"
  end_ip_address      = "${element(var.mysql_webapp_ip, count.index)}"
}
