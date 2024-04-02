terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0, < 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}


## Section to provide a random Azure region for the resource group
# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/regions/azurerm"
  version = ">= 0.3.0"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}
## End of section to provide a random Azure region for the resource group

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
}

# This is required for resource modules
resource "azurerm_resource_group" "poc" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
}

data "azurerm_client_config" "current" {}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "test" {
  source = "../../"


  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.poc.name
  location            = azurerm_resource_group.poc.location

  application_insights = {
    app_insights = {
      name                  = "${var.standard_prefix}-${module.naming.application_insights.name_unique}"
      workspace_object_name = "law1"
    }
  }

  databases = {
    db1 = {
      name               = "${var.standard_prefix}-${module.naming.mssql_database.name_unique}"
      server_object_name = "sql_server"
    }
  }

  log_analytics_workspaces = {
    law1 = {
      name = "${var.standard_prefix}-${module.naming.log_analytics_workspace.name_unique}"
    }
  }

  key_vaults = {
    key_vault = {
      name      = "${var.kv_prefix}${module.naming.key_vault.name_unique}"
      tenant_id = data.azurerm_client_config.current.tenant_id
    }
  }

  servers = {
    sql_server = {
      name                         = "${var.sql_prefix}${module.naming.mssql_server.name_unique}"
      administrator_login          = local.administrator_login
      administrator_login_password = local.administrator_login_password
    }
  }

  service_plans = {
    service_plan = {
      name     = "${var.standard_prefix}-${module.naming.app_service.name_unique}"
      os_type  = "Windows"
      sku_name = "S1"
    }
  }

  storage_accounts = {
    sql_storage_account = {
      name = "${var.sql_prefix}${module.naming.storage_account.name_unique}"
    }
    kv_storage_account = {
      name = "${var.kv_prefix}${module.naming.storage_account.name_unique}"
    }
  }

  web_apps = {
    app1 = {
      name                     = "${var.standard_prefix}-${module.naming.app_service.name_unique}-wb01"
      service_plan_object_name = "service_plan"
      app_insights_object_name = "app_insights"
    }
    app2 = {
      name                     = "${var.standard_prefix}-${module.naming.app_service.name_unique}-ap01"
      service_plan_object_name = "service_plan"
      app_insights_object_name = "app_insights"
    }
  }

}
