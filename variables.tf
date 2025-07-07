variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "mywebapp"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "app_service_sku" {
  description = "App Service Plan SKU"
  type        = string
  default     = "B1"
}

variable "allowed_ips" {
  description = "IP addresses allowed to access Key Vault"
  type        = list(string)
  default     = ["0.0.0.0/0"] 
}