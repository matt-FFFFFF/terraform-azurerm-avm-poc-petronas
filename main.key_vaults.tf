module "keyvault" {
  for_each = { for key_vault, key_vault_values in var.key_vaults : key_vault => key_vault_values }

  source           = "Azure/avm-res-keyvault-vault/azurerm"
  version          = "0.5.3"
  enable_telemetry = var.enable_telemetry

  name                = each.value.name
  location            = coalesce(each.value.location, data.azurerm_resource_group.parent.location)
  resource_group_name = coalesce(each.value.resource_group_name, data.azurerm_resource_group.parent.name)
  tenant_id           = each.value.tenant_id
  tags                = each.value.tags
}