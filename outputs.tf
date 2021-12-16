output "keyvault" {
  description = "azurerm_keyvault results"
  value = {
    for keyvault in keys(azurerm_key_vault.keyvault):
    keyvault => {
      name = azurerm_key_vault.keyvault[keyvault].name
      id   = azurerm_key_vault.keyvault[keyvault].id
    }
  }
}
