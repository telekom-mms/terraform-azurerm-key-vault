/**
* # key_vault
*
* This module manages the hashicorp/azurerm key_vault resources.
* For more information see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs > key_vault
*
*/

resource "azurerm_key_vault" "key_vault" {
  #ts:skip=AC_AZURE_0169 terrascan - metrick logs not part of this module
  for_each = var.key_vault

  name                            = local.key_vault[each.key].name == "" ? each.key : local.key_vault[each.key].name
  location                        = local.key_vault[each.key].location
  resource_group_name             = local.key_vault[each.key].resource_group_name
  sku_name                        = local.key_vault[each.key].sku_name
  tenant_id                       = local.key_vault[each.key].tenant_id
  enabled_for_deployment          = local.key_vault[each.key].enabled_for_deployment
  enabled_for_disk_encryption     = local.key_vault[each.key].enabled_for_disk_encryption
  enabled_for_template_deployment = local.key_vault[each.key].enabled_for_template_deployment
  enable_rbac_authorization       = local.key_vault[each.key].enable_rbac_authorization
  purge_protection_enabled        = local.key_vault[each.key].purge_protection_enabled
  public_network_access_enabled   = local.key_vault[each.key].public_network_access_enabled
  soft_delete_retention_days      = local.key_vault[each.key].soft_delete_retention_days

  dynamic "access_policy" {
    for_each = local.key_vault[each.key].access_policy

    content {
      tenant_id               = local.key_vault[each.key].access_policy[access_policy.key].tenant_id
      object_id               = local.key_vault[each.key].access_policy[access_policy.key].object_id
      application_id          = local.key_vault[each.key].access_policy[access_policy.key].application_id
      certificate_permissions = local.key_vault[each.key].access_policy[access_policy.key].certificate_permissions
      key_permissions         = local.key_vault[each.key].access_policy[access_policy.key].key_permissions
      secret_permissions      = local.key_vault[each.key].access_policy[access_policy.key].secret_permissions
      storage_permissions     = local.key_vault[each.key].access_policy[access_policy.key].storage_permissions
    }
  }

  dynamic "network_acls" {
    for_each = local.key_vault[each.key].network_acls == null ? [] : [0]

    content {
      bypass                     = local.key_vault[each.key].network_acls.bypass
      default_action             = local.key_vault[each.key].network_acls.default_action
      ip_rules                   = local.key_vault[each.key].network_acls.ip_rules
      virtual_network_subnet_ids = local.key_vault[each.key].network_acls.virtual_network_subnet_ids
    }
  }

  dynamic "contact" {
    for_each = local.key_vault[each.key].contact == null ? [] : [0]

    content {
      email = local.key_vault[each.key].contact.email
      name  = local.key_vault[each.key].contact.name
      phone = local.key_vault[each.key].contact.phone
    }
  }

  tags = local.key_vault[each.key].tags
}

resource "azurerm_key_vault_secret" "key_vault_secret" {
  for_each = var.key_vault_secret

  name            = local.key_vault_secret[each.key].name == "" ? each.key : local.key_vault_secret[each.key].name
  value           = local.key_vault_secret[each.key].value
  key_vault_id    = local.key_vault_secret[each.key].key_vault_id
  content_type    = local.key_vault_secret[each.key].content_type
  not_before_date = local.key_vault_secret[each.key].not_before_date
  expiration_date = local.key_vault_secret[each.key].expiration_date
  tags            = local.key_vault_secret[each.key].tags
}
