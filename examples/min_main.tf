provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {}

resource "random_password" "password" {
  for_each = toset(["mysql_root"])

  length  = 16
  special = false
}

module "key_vault" {
  source = "registry.terraform.io/telekom-mms/key-vault/azurerm"
  key_vault = {
    kv-mms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
      tenant_id           = data.azurerm_subscription.current.tenant_id
    }
  }
  key_vault_secret = {
    mysql-root = {
      value        = random_password.password["mysql_root"].result
      key_vault_id = module.key_vault.key_vault["kv-mms"].id
    }
  }
  key_vault_key = {
    mms-key = {
      key_vault_id = module.key_vault.key_vault["kv-mms"].id
    }
  }
}
