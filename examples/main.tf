module "keyvault" {
  source              = "../terraform-keyvault"
  location            = "westeurope"
  resource_name = [
    "service-mgmt-kv",
  ]
  keyvault        = {
    resource_group_name = "service-mgmt-rg"
    tenant_id           = data.azurerm_subscription.current.tenant_id
  }
  keyvault_config = {
    mgmt = {
      access_policies = {
        frontdoor = {
          object_id               = data.azuread_service_principal.frontdoor.object_id
          key_permissions         = []
          certificate_permissions = ["get", ]
          secret_permissions      = ["get", ]
        }
      }
    }
    env = {
      access_policies = {
        admin       = {
          object_id = data.azuread_group.grp-admin.object_id
        }
      }
    }
  }
  tags = {
    service = "service_name"
  }
}
