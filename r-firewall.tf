resource "azurerm_mysql_firewall_rule" "firewall_rules" {
  for_each = var.allowed_cidrs

  name                = replace(replace(each.key, ".", "-"), "/", "_")
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql_server.name
  start_ip_address    = cidrhost(each.value, 0)
  end_ip_address      = cidrhost(each.value, -1)
}
