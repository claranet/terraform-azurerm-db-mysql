output "azure_mysql_firewall_rule_id" {
  value       = "${azurerm_mysql_firewall_rule.mysql_rule.*.id}"
  description = "List of mysql created rules"
}

output "azure_mysql_id" {
  value       = "${azurerm_mysql_server.mysql_server.id}"
  description = "Mysql instance id"
}

output "azure_mysql_fqdn" {
  value       = "${azurerm_mysql_server.mysql_server.fqdn}"
  description = "Mysql generated fqdn"
}

output "azure_mysql_db_name" {
  value       = "${azurerm_mysql_database.mysql_db.name}"
  description = "Database Name"
}

output "azure_mysql_login" {
  value       = "${azurerm_mysql_server.mysql_server.administrator_login}@${azurerm_mysql_server.mysql_server.name}"
  sensitive   = true
  description = "Username"
}

output "azure_mysql_password" {
  value       = "${azurerm_mysql_server.mysql_server.administrator_login_password}"
  sensitive   = true
  description = "Password"
}
