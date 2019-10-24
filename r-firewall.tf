resource "azurerm_mysql_firewall_rule" "firewall_rules" {
  count               = length(var.firewall_rules)
  name                = lookup(var.firewall_rules[count.index], "name", count.index)
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql_server.name
  start_ip_address    = lookup(var.firewall_rules[count.index], "start_ip")
  end_ip_address      = lookup(var.firewall_rules[count.index], "end_ip")
}
