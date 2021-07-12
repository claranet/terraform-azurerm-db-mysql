provider "mysql" {
  alias = "create-users"

  endpoint = format("%s:3306", azurerm_mysql_server.mysql_server.fqdn)
  username = local.administrator_login
  password = local.administrator_password

  tls = var.force_ssl
}
