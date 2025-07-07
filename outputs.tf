output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "web_app_url" {
  description = "URL of the web app"
  value       = module.app.web_app_url
}

output "key_vault_name" {
  description = "Name of the key vault"
  value       = module.keyvault.key_vault_name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage.storage_account_name
}