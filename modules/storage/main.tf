resource "azurerm_storage_account" "main" {
  name                     = "st${var.project_name}${var.environment}${random_id.suffix.hex}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # Security settings
  enable_https_traffic_only = true
  min_tls_version          = "TLS1_2"
  
  # Network Access
  network_rules {
    default_action = "Allow"
    bypass         = ["AzureServices"]
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Storage Endpoint
resource "azurerm_private_endpoint" "storage" {
  name                = "pe-${azurerm_storage_account.main.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id  

  private_service_connection {
    name                           = "psc-storage"
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Storage container for app data
resource "azurerm_storage_container" "app_data" {
  name                  = "app-data"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "random_id" "suffix" {
  byte_length = 4
}