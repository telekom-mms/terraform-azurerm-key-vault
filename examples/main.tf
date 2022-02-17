module "keyvault" {
  source = "registry.terraform.io/T-Systems-MMS/keyvault/azurerm"
  keyvault = {
    mgmt = {
      name                     = "service-mgmt-kv"
      location                 = "westeurope"
      resource_group_name      = "service-mgmt-rg"
      tenant_id                = data.azurerm_subscription.current.tenant_id
      purge_protection_enabled = true

      access_policy = {
        frontdoor = {
          object_id               = data.azuread_service_principal.frontdoor.object_id
          certificate_permissions = ["Get", ]
          secret_permissions      = ["Get", ]
        }
      }

      tags = {
        service = "service_name"
      }
    }
  }
}
