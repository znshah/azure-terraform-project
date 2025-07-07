# Data sources
data "azurerm_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# Network Module
module "network" {
  source = "./modules/network"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  project_name        = var.project_name
  environment         = var.environment
}

# Key Vault Module
module "keyvault" {
  source = "./modules/keyvault"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  project_name        = var.project_name
  environment         = var.environment
  tenant_id           = data.azurerm_client_config.current.tenant_id
  allowed_ips         = var.allowed_ips
}

# Storage Module
module "storage" {
  source = "./modules/storage"
  
  resource_group_name         = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  project_name               = var.project_name
  environment                = var.environment
  subnet_id                  = module.network.subnet_id
  private_endpoint_subnet_id = module.network.private_endpoint_subnet_id  # ADD THIS LINE
}

# App Service Module
module "app" {
  source = "./modules/app"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  project_name        = var.project_name
  environment         = var.environment
  app_service_sku     = var.app_service_sku
  key_vault_id        = module.keyvault.key_vault_id
  subnet_id           = module.network.subnet_id
}

# Key Vault Access
resource "azurerm_key_vault_access_policy" "app_service" {
  key_vault_id = module.keyvault.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.app.app_service_identity_principal_id

  secret_permissions = [
    "Get"
  ]
}

# Database Connection
#resource "azurerm_key_vault_secret" "database_connection" {
#  name         = "database-connection-string"
#  value        = "connection_string_here"
#  key_vault_id = module.keyvault.key_vault_id
#
#  depends_on = [module.keyvault]
#}