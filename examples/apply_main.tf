data "azurerm_subscription" "current" {}

module "key_vault" {
  source = "registry.terraform.io/telekom-mms/key-vault/azurerm"
  key_vault = {
    kv-mms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
      tenant_id           = data.azurerm_subscription.current.tenant_id
    }
  }
}
