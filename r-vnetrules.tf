resource "azurerm_mysql_virtual_network_rule" "vnet_rules" {
  for_each = var.allowed_subnets

  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql_server.name
  subnet_id           = each.value
}
