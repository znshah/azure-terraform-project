data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                = "kv-${var.project_name}-${var.environment}-${random_id.suffix.hex}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = "standard"

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  network_acls {
    default_action = "Allow" 
    bypass         = "AzureServices"
    ip_rules       = var.allowed_ips
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Access policy for current
resource "azurerm_key_vault_access_policy" "current" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List", 
    "Set",
    "Delete",
    "Purge"
  ]
}

resource "random_id" "suffix" {
  byte_length = 4
}