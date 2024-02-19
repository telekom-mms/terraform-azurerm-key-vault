variable "key_vault" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "key_vault_secret" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "key_vault_key" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}

locals {
  default = {
    // resource definition
    key_vault = {
      name                            = ""
      sku_name                        = "standard" // defined default
      enabled_for_deployment          = null
      enabled_for_disk_encryption     = null
      enabled_for_template_deployment = null
      enable_rbac_authorization       = null
      purge_protection_enabled        = true // defined default
      public_network_access_enabled   = null
      soft_delete_retention_days      = null
      access_policy = {
        application_id          = null
        certificate_permissions = null
        key_permissions         = null
        secret_permissions      = null
        storage_permissions     = null
      }
      network_acls = {
        bypass                     = "None" // defined default
        default_action             = "Deny" // defined default
        ip_rules                   = null
        virtual_network_subnet_ids = null
      }
      contact = {
        name  = ""
        phone = ""
      }
      tags = {}
    }
    key_vault_secret = {
      name            = ""
      content_type    = null
      not_before_date = null
      expiration_date = null
      tags            = {}
    }
    key_vault_key = {
      name     = ""
      key_type = "RSA" // defined default
      key_size = 4096  // defined default
      curve    = null
      key_opts = [
        "decrypt",
        "encrypt",
        "sign",
        "verify",
        "wrapKey",
        "unwrapKey"
      ] // defined default
      not_before_date = null
      expiration_date = null
      rotation_policy = {
        automatic = {
          time_after_creation = null
          time_before_expiry  = null
        }
      }
      tags = {}
    }
  }

  // compare and merge custom and default values
  key_vault_values = {
    for key_vault in keys(var.key_vault) :
    key_vault => merge(local.default.key_vault, var.key_vault[key_vault])
  }
  key_vault_key_values = {
    for key_vault_key in keys(var.key_vault_key) :
    key_vault_key => merge(local.default.key_vault_key, var.key_vault_key[key_vault_key])
  }

  // deep merge of all custom and default values
  key_vault = {
    for key_vault in keys(var.key_vault) :
    key_vault => merge(
      local.key_vault_values[key_vault],
      {
        for config in ["access_policy"] :
        config => {
          for key in keys(lookup(var.key_vault[key_vault], config, {})) :
          key => merge(local.default.key_vault[config], local.key_vault_values[key_vault][config][key])
        }
      },
      {
        for config in ["network_acls", "contact"] :
        config => lookup(var.key_vault[key_vault], config, {}) == {} ? null : merge(local.default.key_vault[config], local.key_vault_values[key_vault][config])
      }
    )
  }
  key_vault_secret = {
    for key_vault_secret in keys(var.key_vault_secret) :
    key_vault_secret => merge(local.default.key_vault_secret, var.key_vault_secret[key_vault_secret])
  }
  key_vault_key = {
    for key_vault_key in keys(var.key_vault_key) :
    key_vault_key => merge(
      local.key_vault_key_values[key_vault_key],
      {
        for config in ["rotation_policy"] :
        config => merge(
          merge(local.default.key_vault_key[config], local.key_vault_key_values[key_vault_key][config]),
          {
            for subconfig in ["automatic"] :
            subconfig => merge(local.default.key_vault_key[config][subconfig], lookup(local.key_vault_key_values[key_vault_key][config], subconfig, {}))
          }
        )
      }
    )
  }
}
