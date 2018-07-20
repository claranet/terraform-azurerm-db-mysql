output "azure_mysql_firewall_rule_id" {
  value = "${azurerm_mysql_firewall_rule.mysql_rule.*.id}"
}
output "azure_mysql_id" {
  value = "${azurerm_mysql_server.mysql_server.id}"
}

output "azure_mysql_fqdn" {
  value = "${azurerm_mysql_server.mysql_server.fqdn}"
}

output "azure_mysql_db_name" {
  value = "${azurerm_mysql_database.mysql_db.name}"
}

output "azure_mysql_login" {
  value     = "${azurerm_mysql_server.mysql_server.administrator_login}@${azurerm_mysql_server.mysql_server.name}"
  sensitive = true
}

output "azure_mysql_password" {
  value     = "${azurerm_mysql_server.mysql_server.administrator_login_password}"
  sensitive = true
}
