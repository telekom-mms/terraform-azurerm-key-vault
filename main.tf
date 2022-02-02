/**
 * # keyvault
 *
 * This module manages Azure KeyVault.
 *
*/
resource "azurerm_key_vault" "keyvault" {
  for_each = var.keyvault

  name                = local.keyvault[each.key].name == "" ? each.key : local.keyvault[each.key].name
  location            = local.keyvault[each.key].location
  resource_group_name = local.keyvault[each.key].resource_group_name
  tenant_id           = local.keyvault[each.key].tenant_id
  sku_name            = local.keyvault[each.key].sku_name

  enabled_for_deployment          = local.keyvault[each.key].enabled_for_deployment
  enabled_for_disk_encryption     = local.keyvault[each.key].enabled_for_disk_encryption
  enabled_for_template_deployment = local.keyvault[each.key].enabled_for_template_deployment
  enable_rbac_authorization       = local.keyvault[each.key].enable_rbac_authorization
  purge_protection_enabled        = local.keyvault[each.key].purge_protection_enabled
  soft_delete_retention_days      = local.keyvault[each.key].soft_delete_retention_days

  dynamic "access_policy" {
    for_each = local.keyvault[each.key].access_policy

    content {
      tenant_id = local.keyvault[each.key].tenant_id
      object_id = local.keyvault[each.key].access_policy[access_policy.key].object_id

      key_permissions         = local.keyvault[each.key].access_policy[access_policy.key].key_permissions
      certificate_permissions = local.keyvault[each.key].access_policy[access_policy.key].certificate_permissions
      secret_permissions      = local.keyvault[each.key].access_policy[access_policy.key].secret_permissions
      storage_permissions     = local.keyvault[each.key].access_policy[access_policy.key].storage_permissions
    }
  }

  dynamic "network_acls" {
    for_each = local.keyvault[each.key].network_acls

    content {
      bypass                     = local.keyvault[each.key].network_acls[network_acls.key].bypass
      default_action             = local.keyvault[each.key].network_acls[network_acls.key].bypdefault_actionass
      ip_rules                   = local.keyvault[each.key].network_acls[network_acls.key].ip_rules
      virtual_network_subnet_ids = local.keyvault[each.key].network_acls[network_acls.key].virtual_network_subnet_ids
    }
  }

  dynamic "contact" {
    for_each = local.keyvault[each.key].contact

    content {
      email = local.keyvault[each.key].contact[contact.key].email
      name  = local.keyvault[each.key].contact[contact.key].name
      phone = local.keyvault[each.key].contact[contact.key].phone
    }
  }

  tags = local.keyvault[each.key].tags

  lifecycle {
    prevent_destroy = false
  }
}
