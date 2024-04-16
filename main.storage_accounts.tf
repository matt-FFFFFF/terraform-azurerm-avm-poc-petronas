# module "avm_res_storage_storageaccount" {
#   source  = "Azure/avm-res-storage-storageaccount/azurerm"
#   version = "0.1.1"

#   name                          = "stg${var.naming_suffix}"
#   resource_group_name           = azurerm_resource_group.this.name
#   location                      = var.location
#   shared_access_key_enabled     = true
#   public_network_access_enabled = true
#   network_rules = {
#     bypass         = ["AzureServices"]
#     default_action = "Allow"
#   }
# }
