output "mysql_administrator_login" {
  value       = local.administrator_login
  description = "Administrator login for MySQL server"
}

output "mysql_administrator_password" {
  value       = local.administrator_password
  description = "Administrator password for mysql server"
  sensitive   = true
}

output "mysql_databases" {
  value       = azurerm_mysql_database.mysql_db
  description = "Map of databases infos"
}

output "mysql_databases_names" {
  value       = [for db in azurerm_mysql_database.mysql_db : db.name]
  description = "List of databases names"
}

output "mysql_database_ids" {
  description = "The list of all database resource ids"
  value       = [for db in azurerm_mysql_database.mysql_db : db.id]
}

output "mysql_firewall_rule_ids" {
  value       = azurerm_mysql_firewall_rule.firewall_rules
  description = "Map of MySQL created rules"
}

output "mysql_fqdn" {
  value       = azurerm_mysql_server.mysql_server.fqdn
  description = "FQDN of the MySQL server"
}

output "mysql_server_id" {
  value       = azurerm_mysql_server.mysql_server.id
  description = "MySQL server ID"
}

output "mysql_server_name" {
  value       = azurerm_mysql_server.mysql_server.name
  description = "MySQL server name"
}

output "mysql_vnet_rules" {
  value       = azurerm_mysql_virtual_network_rule.vnet_rules
  description = "The map of all vnet rules"
}

output "mysql_databases_users" {
  description = "Map of user name for each database"
  value       = { for db, c in var.databases : db => mysql_user.users[db].user if length(mysql_user.users) > 0 }
}

output "mysql_databases_logins" {
  description = "Map of user login for each database"
  value       = { for db, c in var.databases : db => format("%s@%s", mysql_user.users[db].user, azurerm_mysql_server.mysql_server.name) if length(mysql_user.users) > 0 }
}

output "mysql_databases_passwords" {
  description = "Map of user password for each database"
  value       = { for db, c in var.databases : db => random_password.db_passwords[db].result if length(random_password.db_passwords) > 0 }
  sensitive   = true
}
