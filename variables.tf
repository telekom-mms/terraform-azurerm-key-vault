variable "resource_name" {
  type    = set(string)
  default     = {}
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
      sku_name = "standard"
    }
    # resource configuration
    keyvault_config = {
      access_policies = {
        key_permissions         = ["create", "get", "list", "update", "delete", "get", "import", "sign", ]
        certificate_permissions = ["create", "get", "list", "update", "delete", "get", "import", ]
        secret_permissions      = ["set", "list", "get", "delete", ]
      }
    }
  }

  # merge custom and default values
  tags     = merge(local.default.tags, var.tags)
  keyvault = merge(local.default.keyvault, var.keyvault)

  # deep merge over merged config and use defaults if no variable is set
  keyvault_config = {
    # get all config
    for config in keys(var.keyvault_config) :
    instance => {
      for config in keys(local.default.keyvault_config) :
      config =>
        merge(local.default.keyvault_config, local.merged.keyvault_config[instance][config])
    }
  }
}
