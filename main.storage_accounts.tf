module "avm_res_storage_storageaccount" {
  for_each = { for storage_account, storage_account_values in var.storage_accounts : storage_account => storage_account_values }

  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.1.1"

  enable_telemetry = var.enable_telemetry

  name                          = each.value.name
  resource_group_name           = coalesce(each.value.resource_group_name, data.azurerm_resource_group.parent.name)
  location                      = coalesce(each.value.location, data.azurerm_resource_group.parent.location)
  shared_access_key_enabled     = true
  public_network_access_enabled = true
  network_rules = {
    bypass         = ["AzureServices"]
    default_action = "Allow"
  }
  tags = {
    environment = "PoC"
    language    = "Terraform"
  }
}