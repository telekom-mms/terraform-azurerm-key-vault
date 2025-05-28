output "key_vault" {
  description = "Outputs all attributes of resource_type."
  value = {
    for key_vault in keys(azurerm_key_vault.key_vault) :
    key_vault => {
      for key, value in azurerm_key_vault.key_vault[key_vault] :
      key => value
    }
  }
}

output "key_vault_secret" {
  description = "Outputs all attributes of resource_type."
  value = {
    for key_vault_secret in keys(azurerm_key_vault_secret.key_vault_secret) :
    key_vault_secret => {
      for key, value in azurerm_key_vault_secret.key_vault_secret[key_vault_secret] :
      key => value
    }
  }
}

output "key_vault_key" {
  description = "Outputs all attributes of resource_type."
  value = {
    for key_vault_key in keys(azurerm_key_vault_key.key_vault_key) :
    key_vault_key => {
      for key, value in azurerm_key_vault_key.key_vault_key[key_vault_key] :
      key => value
    }
  }
}

output "variables" {
  description = "Displays all configurable variables passed by the module. __default__ = predefined values per module. __merged__ = result of merging the default values and custom values passed to the module"
  value = {
    default = {
      for variable in keys(local.default) :
      variable => local.default[variable]
    }
    merged = {
      key_vault = {
        for key in keys(var.key_vault) :
        key => local.key_vault[key]
      }
      key_vault_secret = {
        for key in keys(var.key_vault_secret) :
        key => local.key_vault_secret[key]
      }
      key_vault_key = {
        for key in keys(var.key_vault_key) :
        key => local.key_vault_key[key]
      }
    }
  }
}
