/**
 * # keyvault
 *
 * This module manages Azure Keyvault Configuration.
 *
*/
resource "azurerm_key_vault" "keyvault" {
  for_each = var.resource_name

  name                = each.value
  location            = var.location
  resource_group_name = local.keyvault.resource_group_name
  tenant_id           = local.keyvault.tenant_id
  sku_name            = local.keyvault.sku_name

  enabled_for_deployment          = local.keyvault.enabled_for_deployment
  enabled_for_disk_encryption     = local.keyvault.enabled_for_disk_encryption
  enabled_for_template_deployment = local.keyvault.enabled_for_template_deployment
  enable_rbac_authorization       = local.keyvault.enable_rbac_authorization
  purge_protection_enabled        = local.keyvault.purge_protection_enabled
  soft_delete_retention_days      = local.keyvault.soft_delete_retention_days

  dynamic "access_policy" {
    for_each = local.keyvault_config.access_policies

    content {
      tenant_id = local.keyvault.tenant_id
      object_id = local.keyvault_config.access_policies[access_policy.key].object_id

      key_permissions         = local.keyvault_config.access_policies[access_policy.key].key_permissions
      certificate_permissions = local.keyvault_config.access_policies[access_policy.key].certificate_permissions
      secret_permissions      = local.keyvault_config.access_policies[access_policy.key].secret_permissions
      storage_permissions     = local.keyvault_config.access_policies[access_policy.key].storage_permissions
    }
  }

  dynamic "network_acls" {
    for_each = local.keyvault_config.network_acls

    content {
      bypass                     = local.keyvault_config.network_acls[network_acls.key].bypass
      default_action             = local.keyvault_config.network_acls[network_acls.key].bypdefault_actionass
      ip_rules                   = local.keyvault_config.network_acls[network_acls.key].ip_rules
      virtual_network_subnet_ids = local.keyvault_config.network_acls[network_acls.key].virtual_network_subnet_ids
    }
  }

  dynamic "contact" {
    for_each = local.keyvault_config.contact

    content {
      email = local.keyvault_config.contact[network_acls.key].email
      name  = local.keyvault_config.contact[network_acls.key].name
      phone = local.keyvault_config.contact[network_acls.key].phone
    }
  }

  tags = {
    for tag in keys(local.tags) :
    tag => local.tags[tag]
  }

  lifecycle {
    prevent_destroy = true
  }
}
