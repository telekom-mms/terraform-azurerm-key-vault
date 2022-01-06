variable "resource_name" {
  type        = set(string)
  default     = []
  description = "Azure Keyvault"
}
variable "location" {
  type        = string
  description = "location where the resource should be created"
}
variable "tags" {
  type        = any
  default     = {}
  description = "mapping of tags to assign, default settings are defined within locals and merged with var settings"
}
# resource definition
variable "keyvault" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
# resource configuration
variable "keyvault_config" {
  type        = any
  default     = {}
  description = "resource configuration, default settings are defined within locals and merged with var settings"
}

locals {
  default = {
    tags = {}
    # resource definition
    keyvault = {
      sku_name                        = "standard"
      enabled_for_deployment          = false
      enabled_for_disk_encryption     = false
      enabled_for_template_deployment = false
      enable_rbac_authorization       = false
      purge_protection_enabled        = false
      soft_delete_retention_days      = 90
    }
    # resource configuration
    keyvault_config = {
      access_policies = {
        key_permissions         = []
        certificate_permissions = []
        secret_permissions      = []
        storage_permissions     = []
      }
      network_acls = {}
      contact      = {}
    }
  }

  # merge custom and default values
  tags     = merge(local.default.tags, var.tags)
  keyvault = merge(local.default.keyvault, var.keyvault)

  # deep merge over merged config and use defaults if no variable is set
  keyvault_config = {
    for config in keys(local.default.keyvault_config) :
    config => {
      for instance in keys(var.keyvault_config[config]) :
      instance => merge(local.default.keyvault_config[config], var.keyvault_config[config][instance])
    }
  }
}
