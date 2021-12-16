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

  dynamic "access_policy" {
    for_each = local.keyvault_config.access_policies

    content {
      tenant_id = local.keyvault.tenant_id
      object_id = local.keyvault_config.access_policies[access_policy.key].object_id

      key_permissions         = local.keyvault_config.access_policies[access_policy.key].key_permissions
      certificate_permissions = local.keyvault_config.access_policies[access_policy.key].certificate_permissions
      secret_permissions      = local.keyvault_config.access_policies[access_policy.key].secret_permissions
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
