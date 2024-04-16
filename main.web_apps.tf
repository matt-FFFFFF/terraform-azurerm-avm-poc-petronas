resource "azurerm_log_analytics_workspace" "this" {
  location            = azurerm_resource_group.this.location
  name                = "law${var.naming_suffix}"
  resource_group_name = azurerm_resource_group.this.name
  retention_in_days   = 30
  sku                 = "PerGB2018"
}

resource "azurerm_application_insights" "this" {
  application_type    = "web"
  location            = azurerm_resource_group.this.location
  name                = "aa${var.naming_suffix}"
  resource_group_name = azurerm_resource_group.this.name
  workspace_id        = azurerm_log_analytics_workspace.this.id
}

resource "azurerm_service_plan" "this" {
  location            = azurerm_resource_group.this.location
  name                = "sp${var.naming_suffix}"
  os_type             = "Windows"
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "D1"
}

module "avm_res_web_site" {
  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.2.0"

  name                     = "site${var.naming_suffix}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  service_plan_resource_id = azurerm_service_plan.this.id
  app_settings             = { "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.this.connection_string }
  kind                     = "webapp"
  os_type                  = azurerm_service_plan.this.os_type
  site_config = {
    use_32_bit_worker = true
  }
}
