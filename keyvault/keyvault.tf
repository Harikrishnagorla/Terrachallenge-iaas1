resource "azurerm_key_vault" "Terra-kv" {
  name                        = "Terra-kv"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = "f7f66891-a582-418d-999e-cb1be5354253"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  depends_on = [ azurerm_resource_group.terrachallenge ]

  sku_name = "standard"

  access_policy {
    tenant_id = "f7f66891-a582-418d-999e-cb1be5354253"
    object_id = "fd544499-54ab-4b9f-85db-1bda02786361"

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get", "Set", "List"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true

}


resource "azurerm_key_vault_secret" "Windows-sec" {
  name         = "test0"
  value        = random_password.password.result
  content_type = "admin password for windows "
  key_vault_id = azurerm_key_vault.Terra-kv.id
  depends_on = [  azurerm_resource_group.terrachallenge]


}
resource "azurerm_key_vault_secret" "linux-sec" {
  name         = "test1"
  value        = random_password.password.result
  content_type = "admin password for linux"
  key_vault_id = azurerm_key_vault.Terra-kv.id
  depends_on = [ azurerm_resource_group.terrachallenge ]
  
}