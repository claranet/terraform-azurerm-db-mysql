resource "random_password" "db_passwords" {
  for_each = toset(var.create_databases_users ? keys(var.databases) : [])

  special = false
  length  = 32
}

resource "mysql_user" "users" {
  for_each = toset(var.create_databases_users ? keys(var.databases) : [])

  provider = mysql.users_mgmt

  user               = format("%s%s", each.key, local.user_suffix)
  plaintext_password = random_password.db_passwords[each.key].result
  host               = "%"

  depends_on = [azurerm_mysql_database.mysql_db, azurerm_mysql_firewall_rule.firewall_rules]
}

resource "mysql_grant" "roles" {
  for_each = toset(var.create_databases_users ? keys(var.databases) : [])

  provider = mysql.users_mgmt

  user       = format("%s%s", each.key, local.user_suffix)
  host       = "%"
  database   = each.key
  privileges = ["ALL PRIVILEGES"]

  depends_on = [mysql_user.users]
}
