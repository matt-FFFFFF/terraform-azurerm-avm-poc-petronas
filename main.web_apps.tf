resource "azurerm_log_analytics_workspace" "this" {
  for_each = { for log_analytics_workspaces, log_analytics_workspaces_values in var.log_analytics_workspaces : log_analytics_workspaces => log_analytics_workspaces_values }

  location            = coalesce(each.value.location, data.azurerm_resource_group.parent.location) # data.azurerm_resource_group.exisitng.location
  name                = each.value.name
  resource_group_name = coalesce(each.value.resource_group_name, data.azurerm_resource_group.parent.name)
  retention_in_days   = each.value.retention_in_days
  sku                 = each.value.sku
  tags                = each.value.tags
}

resource "azurerm_application_insights" "this" {
  for_each = { for application_insights, application_insights_values in var.application_insights : application_insights => application_insights_values }

  application_type    = "web"
  location            = coalesce(each.value.location, data.azurerm_resource_group.parent.location) # data.azurerm_resource_group.exisitng.location
  name                = each.value.name
  resource_group_name = coalesce(each.value.resource_group_name, data.azurerm_resource_group.parent.name)
  tags                = each.value.tags
  workspace_id        = coalesce(each.value.workspace_resource_id, azurerm_log_analytics_workspace.this[each.value.workspace_object_name].id)
}

resource "azurerm_service_plan" "this" {
  for_each = { for service_plan, service_plan_values in var.service_plans : service_plan => service_plan_values }

  location            = coalesce(each.value.location, data.azurerm_resource_group.parent.location)
  name                = each.value.name
  os_type             = each.value.os_type
  resource_group_name = coalesce(each.value.resource_group_name, data.azurerm_resource_group.parent.name)
  sku_name            = each.value.sku_name
  tags                = each.value.tags
}

module "avm_res_web_site" {
  for_each = { for web_app, web_app_values in var.web_apps : web_app => web_app_values }

  source           = "Azure/avm-res-web-site/azurerm"
  version          = "0.2.0"
  enable_telemetry = var.enable_telemetry

  name                     = each.value.name
  resource_group_name      = coalesce(each.value.resource_group_name, data.azurerm_resource_group.parent.name)
  location                 = coalesce(each.value.location, data.azurerm_resource_group.parent.location) # data.azurerm_resource_group.exisitng.location
  service_plan_resource_id = coalesce(each.value.service_plan_resource_id, azurerm_service_plan.this[each.value.service_plan_object_name].id)
  app_settings             = var.application_insights != null ? merge({ "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.this[each.value.app_insights_object_name].connection_string }, each.value.app_settings) : each.value.app_settings
  kind                     = "webapp"
  os_type                  = coalesce(each.value.os_type, azurerm_service_plan.this[each.value.service_plan_object_name].os_type)
  tags                     = each.value.tags

}