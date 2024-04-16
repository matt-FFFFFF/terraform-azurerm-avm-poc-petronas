resource "random_password" "sqladmin" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_mssql_server" "this" {
  location                     = azurerm_resource_group.this.location
  name                         = "sql${var.naming_suffix}"
  resource_group_name          = azurerm_resource_group.this.name
  version                      = "12.0"
  administrator_login          = "admin${var.naming_suffix}"
  administrator_login_password = random_password.sqladmin.result
}

resource "azurerm_mssql_database" "this" {
  name                        = "db${var.naming_suffix}"
  server_id                   = azurerm_mssql_server.this.id
  auto_pause_delay_in_minutes = -1
  collation                   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb                 = 4
  min_capacity                = 0.5
  sku_name                    = "GP_S_Gen5_2"
}
