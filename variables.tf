variable "keyvault" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}

locals {
  default = {
    # resource definition
    keyvault = {
      name                            = ""
      sku_name                        = "standard"
      enabled_for_deployment          = false
      enabled_for_disk_encryption     = false
      enabled_for_template_deployment = false
      enable_rbac_authorization       = false
      purge_protection_enabled        = false
      soft_delete_retention_days      = 90
      access_policy = {
        key_permissions         = []
        certificate_permissions = []
        secret_permissions      = []
        storage_permissions     = []
      }
      network_acls = {}
      contact      = {}
      tags         = {}
    }
  }

  # compare and merge custom and default values
  keyvault_values = {
    for keyvault in keys(var.keyvault) :
    keyvault => merge(local.default.keyvault, var.keyvault[keyvault])
  }

  # merge all custom and default values
  keyvault = {
    for keyvault in keys(var.keyvault) :
    keyvault => merge(
      local.keyvault_values[keyvault],
      {
        for config in ["access_policy","network_acls","contact"] :
        config => {
          for key in keys(local.keyvault_values[keyvault][config]) :
          key => merge(local.default.keyvault[config], local.keyvault_values[keyvault][config][key])
        }
      }
    )
  }
}
