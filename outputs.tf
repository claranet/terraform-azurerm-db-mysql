output "mysql_administrator_login" {
  value       = "${azurerm_mysql_server.mysql_server.administrator_login}@${azurerm_mysql_server.mysql_server.name}"
  description = "Administrator login for MySQL server"
}

output "mysql_databases_names" {
  value       = azurerm_mysql_database.mysql_db.*.name
  description = "List of databases names"
}

output "mysql_firewall_rule_ids" {
  value       = azurerm_mysql_firewall_rule.mysql_rule.*.id
  description = "List of MySQL created rules"
}

output "mysql_fqdn" {
  value       = azurerm_mysql_server.mysql_server.fqdn
  description = "FQDN of the MySQL server"
}

output "mysql_server_id" {
  value       = azurerm_mysql_server.mysql_server.id
  description = "MySQL server ID"
}

