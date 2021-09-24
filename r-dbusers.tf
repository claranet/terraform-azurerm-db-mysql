resource "random_password" "db_passwords" {
  for_each = var.create_databases_users ? toset(keys(var.databases)) : []

  special = false
  length  = 32
}

resource "mysql_user" "users" {
  for_each = var.create_databases_users ? toset(keys(var.databases)) : []

  provider = mysql.create-users

  user               = var.enable_user_suffix ? format("%s_user", each.key) : each.key
  plaintext_password = random_password.db_passwords[each.key].result
  host               = "%"

  depends_on = [azurerm_mysql_database.mysql_db, azurerm_mysql_firewall_rule.firewall_rules]
}

resource "mysql_grant" "roles" {
  for_each = var.create_databases_users ? toset(keys(var.databases)) : []

  provider = mysql.create-users

  user       = var.enable_user_suffix ? format("%s_user", each.key) : each.key
  host       = "%"
  database   = each.key
  privileges = ["ALL PRIVILEGES"]

  depends_on = [mysql_user.users]
}
