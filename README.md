<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-template

This is a template repo for Terraform Azure Verified Modules.

Things to do:

1. Set up a GitHub repo environment called `test`.
1. Configure environment protection rule to ensure that approval is required before deploying to this environment.
1. Create a user-assigned managed identity in your test subscription.
1. Create a role assignment for the managed identity on your test subscription, use the minimum required role.
1. Configure federated identity credentials on the user assigned managed identity. Use the GitHub environment.
1. Search and update TODOs within the code and remove the TODO comments once complete.

> [!IMPORTANT]
> As the overall AVM framework is not GA (generally available) yet - the CI framework and test automation is not fully functional and implemented across all supported languages yet - breaking changes are expected, and additional customer feedback is yet to be gathered and incorporated. Hence, modules **MUST NOT** be published at version `1.0.0` or higher at this time.
>
> All module **MUST** be published as a pre-release version (e.g., `0.1.0`, `0.1.1`, `0.2.0`, etc.) until the AVM framework becomes GA.
>
> However, it is important to note that this **DOES NOT** mean that the modules cannot be consumed and utilized. They **CAN** be leveraged in all types of environments (dev, test, prod etc.). Consumers can treat them just like any other IaC module and raise issues or feature requests against them as they learn from the usage of the module. Consumers should also read the release notes for each version, if considering updating to a more recent version of a module to see if there are any considerations or breaking changes etc.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.5.0)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (>= 1.9.0, < 2.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.71)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.71)

## Resources

The following resources are used by this module:

- [azurerm_application_insights.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) (resource)
- [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) (resource)
- [azurerm_mssql_database.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) (resource)
- [azurerm_mssql_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) (resource)
- [azurerm_service_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) (resource)
- [azurerm_resource_group.parent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_application_insights"></a> [application\_insights](#input\_application\_insights)

Description:   One or more application insights instances to create. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.  
  Reference an existing workspace by `workspace_resource_id` or reference a new workspace to be created `workspace_object_name`.

Type:

```hcl
map(object({
    name                = string
    resource_group_name = optional(string, null)
    location            = optional(string, null)
    # retention_in_days   = optional(number, 30)
    workspace_resource_id = optional(string, null)
    workspace_object_name = optional(string, null)
    tags                  = optional(map(any), {})
  }))
```

Default: `{}`

### <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key)

Description: Customer managed keys that should be associated with the resource.

Type:

```hcl
object({
    key_vault_resource_id              = optional(string)
    key_name                           = optional(string)
    key_version                        = optional(string, null)
    user_assigned_identity_resource_id = optional(string, null)
  })
```

Default: `{}`

### <a name="input_databases"></a> [databases](#input\_databases)

Description:   Microft SQL Database instances to create. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.  
  Use `server_resource_id` to reference an existing server or `server_object_name` to reference a new server to be created.

Type:

```hcl
map(object({
    name               = string
    server_resource_id = optional(string, null)
    server_object_name = optional(string, null)
    tags               = optional(map(any), {})
  }))
```

Default: `{}`

### <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings)

Description: A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
- `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
- `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
- `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
- `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
- `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
- `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
- `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.

Type:

```hcl
map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_key_vaults"></a> [key\_vaults](#input\_key\_vaults)

Description:

Type:

```hcl
map(object({
    name                = string
    resource_group_name = optional(string, null)
    location            = optional(string, null)
    tenant_id           = string
    tags                = optional(map(any), {})
  }))
```

Default: `{}`

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region where the resource should be deployed.  If null, the location will be inferred from the resource group location.

Type: `string`

Default: `null`

### <a name="input_lock"></a> [lock](#input\_lock)

Description: The lock level to apply. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`.

Type:

```hcl
object({
    name = optional(string, null)
    kind = optional(string, "None")
  })
```

Default: `{}`

### <a name="input_log_analytics_workspaces"></a> [log\_analytics\_workspaces](#input\_log\_analytics\_workspaces)

Description:
# tflint-ignore: terraform\_unused\_declarations  
variable "managed\_identities" {  
  type = object({  
    system\_assigned            = optional(bool, false)  
    user\_assigned\_resource\_ids = optional(set(string), [])
  })  
  default     = {}  
  description = "Managed identities to be created for the resource."
}

variable "private\_endpoints" {  
  type = map(object({  
    name = optional(string, null)  
    role\_assignments = optional(map(object({  
      role\_definition\_id\_or\_name             = string  
      principal\_id                           = string  
      description                            = optional(string, null)  
      skip\_service\_principal\_aad\_check       = optional(bool, false)  
      condition                              = optional(string, null)  
      condition\_version                      = optional(string, null)  
      delegated\_managed\_identity\_resource\_id = optional(string, null)
    })), {})  
    lock = optional(object({  
      name = optional(string, null)  
      kind = optional(string, "None")
    }), {})  
    tags                                    = optional(map(any), null)  
    subnet\_resource\_id                      = string  
    private\_dns\_zone\_group\_name             = optional(string, "default")  
    private\_dns\_zone\_resource\_ids           = optional(set(string), [])  
    application\_security\_group\_associations = optional(map(string), {})  
    private\_service\_connection\_name         = optional(string, null)  
    network\_interface\_name                  = optional(string, null)  
    location                                = optional(string, null)  
    resource\_group\_name                     = optional(string, null)  
    ip\_configurations = optional(map(object({  
      name               = string  
      private\_ip\_address = string
    })), {})
  }))  
  default     = {}  
  description = <<DESCRIPTION  
A map of private endpoints to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the private endpoint. One will be generated if not set.
- `role_assignments` - (Optional) A map of role assignments to create on the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time. See `var.role_assignments` for more information.
- `lock` - (Optional) The lock level to apply to the private endpoint. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`.
- `tags` - (Optional) A mapping of tags to assign to the private endpoint.
- `subnet_resource_id` - The resource ID of the subnet to deploy the private endpoint in.
- `private_dns_zone_group_name` - (Optional) The name of the private DNS zone group. One will be generated if not set.
- `private_dns_zone_resource_ids` - (Optional) A set of resource IDs of private DNS zones to associate with the private endpoint. If not set, no zone groups will be created and the private endpoint will not be associated with any private DNS zones. DNS records must be managed external to this module.
- `application_security_group_resource_ids` - (Optional) A map of resource IDs of application security groups to associate with the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
- `private_service_connection_name` - (Optional) The name of the private service connection. One will be generated if not set.
- `network_interface_name` - (Optional) The name of the network interface. One will be generated if not set.
- `location` - (Optional) The Azure location where the resources will be deployed. Defaults to the location of the resource group.
- `resource_group_name` - (Optional) The resource group where the resources will be deployed. Defaults to the resource group of this resource.
- `ip_configurations` - (Optional) A map of IP configurations to create on the private endpoint. If not specified the platform will create one. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
  - `name` - The name of the IP configuration.
  - `private_ip_address` - The private IP address of the IP configuration.

Type:

```hcl
map(object({
    name                = string
    resource_group_name = optional(string, null)
    location            = optional(string, null)
    retention_in_days   = optional(number, 30)
    sku                 = optional(string, "PerGB2018")
    tags                = optional(map(any), {})
  }))
```

Default: `{}`

### <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments)

Description: A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.

Type:

```hcl
map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_servers"></a> [servers](#input\_servers)

Description:   Microft SQL Database Server instances to create. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

Type:

```hcl
map(object({
    name                         = string
    resource_group_name          = optional(string, null)
    location                     = optional(string, null)
    version                      = optional(string, "12.0")
    administrator_login          = optional(string, "DBAdmin")
    administrator_login_password = optional(string, "P@55word1234")
    tags                         = optional(map(any), {})
  }))
```

Default: `{}`

### <a name="input_service_plans"></a> [service\_plans](#input\_service\_plans)

Description:

Type:

```hcl
map(object({
    name                = string
    resource_group_name = optional(string, null)
    location            = optional(string, null)
    os_type             = optional(string, "Windows")
    sku_name            = optional(string, "S1")
    tags                = optional(map(string), {})
  }))
```

Default: `{}`

### <a name="input_storage_accounts"></a> [storage\_accounts](#input\_storage\_accounts)

Description:

Type:

```hcl
map(object({
    name                     = string
    resource_group_name      = optional(string, null)
    location                 = optional(string, null)
    account_tier             = optional(string, "Standard")
    account_replication_type = optional(string, "LRS")
    # enable_blob_encryption         = optional(bool, false)
    # enable_file_encryption         = optional(bool, false)
    # enable_hns                     = optional(bool, false)
    # enable_https_traffic_only       = optional(bool, false)
    # enable_large_file_share         = optional(bool, false)
    # enable_queue_encryption         = optional(bool, false)
    # enable_table_encryption         = optional(bool, false)
    # enable_versioning              = optional(bool, false)
    # network_rules = optional(object({
    #   bypass         = optional(set(string), ["AzureServices"])
    #   default_action = optional(string, "Allow")
    # }), {})
    tags = optional(map(any), {})
  }))
```

Default: `{}`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: The map of tags to be applied to the resource

Type: `map(any)`

Default: `{}`

### <a name="input_web_apps"></a> [web\_apps](#input\_web\_apps)

Description:

Type:

```hcl
map(object({
    name                     = string
    resource_group_name      = optional(string, null)
    location                 = optional(string, null)
    service_plan_resource_id = optional(string, null)
    service_plan_object_name = optional(string, null)
    app_insights_object_name = optional(string, null)
    app_settings             = optional(map(string), {})
    os_type                  = optional(string, null)
    tags                     = optional(map(string), {})
  }))
```

Default: `{}`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_avm_res_storage_storageaccount"></a> [avm\_res\_storage\_storageaccount](#module\_avm\_res\_storage\_storageaccount)

Source: Azure/avm-res-storage-storageaccount/azurerm

Version: 0.1.1

### <a name="module_avm_res_web_site"></a> [avm\_res\_web\_site](#module\_avm\_res\_web\_site)

Source: Azure/avm-res-web-site/azurerm

Version: 0.2.0

### <a name="module_keyvault"></a> [keyvault](#module\_keyvault)

Source: Azure/avm-res-keyvault-vault/azurerm

Version: 0.5.3

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->