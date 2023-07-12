data "azurerm_subscription" "current" {}

module "key_vault" {
  source = "registry.terraform.io/telekom-mms/key-vault/azurerm"
  key_vault = {
    kv-mms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
      tenant_id           = data.azurerm_subscription.current.tenant_id
      network_acls = {
        bypass   = "AzureServices"
        ip_rules = ["172.0.0.2"]
      }
      tags = {
        project     = "mms-github"
        environment = terraform.workspace
        managed-by  = "terraform"
      }
    }
  }
}
