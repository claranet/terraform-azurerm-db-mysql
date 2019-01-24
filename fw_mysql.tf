resource "azurerm_mysql_firewall_rule" "mysql_rule" {
  name                = "mysql-rule-${replace(cidrhost(element(var.allowed_ip_addressess, count.index), 0),".","-")}"
  count               = "${length(var.allowed_ip_addressess)}"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_mysql_server.mysql_server.name}"
  start_ip_address    = "${cidrhost(element(var.allowed_ip_addressess, count.index), 0)}"
  end_ip_address      = "${cidrhost(element(var.allowed_ip_addressess, count.index), -1)}"
}
