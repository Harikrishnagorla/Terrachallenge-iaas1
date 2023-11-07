output "windows-password" {
  value = azurerm_key_vault_secret.Windows-sec
}

output "linux-password" {
  value = azurerm_key_vault_secret.linux-sec
}







