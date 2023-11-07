resource "azurerm_recovery_services_vault" "Terra-Vault" {
  name                = "Terra-Vault"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  soft_delete_enabled = true
  depends_on = [ azurerm_resource_group.terrachallenge ]
}

resource "azurerm_backup_policy_vm" "terra-backup-policy" {
  name                = "terra-backup-policy"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.Terra-Vault.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 10
  }

  retention_weekly {
    count    = 42
    weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
  }

  retention_monthly {
    count    = 7
    weekdays = ["Sunday", "Wednesday"]
    weeks    = ["First", "Last"]
  }

  retention_yearly {
    count    = 77
    weekdays = ["Sunday"]
    weeks    = ["Last"]
    months   = ["January"]
  }
}

resource "azurerm_backup_protected_vm" "vm" {
  resource_group_name = var.resource_group_name
  recovery_vault_name = "Terra-Vault"
  source_vm_id        = azurerm_linux_virtual_machine.LinuxVM.id
  backup_policy_id    = azurerm_backup_policy_vm.terra-backup-policy.id

  depends_on = [ azurerm_resource_group.terrachallenge ]
  
}
