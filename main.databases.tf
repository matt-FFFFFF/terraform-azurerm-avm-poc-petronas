resource "azurerm_mssql_server" "this" {
  for_each = { for server, server_values in var.servers : server => server_values }

  location                     = coalesce(each.value.location, data.azurerm_resource_group.parent.location)
  name                         = each.value.name
  resource_group_name          = coalesce(each.value.resource_group_name, data.azurerm_resource_group.parent.name)
  version                      = each.value.version
  administrator_login          = each.value.administrator_login
  administrator_login_password = each.value.administrator_login_password
  tags                         = each.value.tags
}

resource "azurerm_mssql_database" "this" {
  for_each = { for database, database_values in var.databases : database => database_values }

  name                        = each.value.name
  server_id                   = coalesce(each.value.server_resource_id, azurerm_mssql_server.this[each.value.server_object_name].id)
  auto_pause_delay_in_minutes = -1
  collation                   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb                 = 4
  min_capacity                = 0.5
  sku_name                    = "GP_S_Gen5_2"
  tags                        = each.value.tags
}