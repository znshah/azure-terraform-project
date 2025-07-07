# Azure Web App Infrastructure

Terraform configuration for deploying a web application on Azure with basic security and monitoring.

## What it creates

- App Service with Linux container support
- Key Vault for secrets management
- Virtual Network with subnet isolation
- Storage account with private endpoint
- Application Insights for monitoring

## Setup

1. Install Terraform and Azure CLI
2. Login to Azure: `az login`
3. Update backend configuration in `terraform.tf`
4. Run:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Configuration

Main variables in `variables.tf`:
- `project_name` - prefix for resources
- `environment` - dev/staging/prod
- `location` - Azure region
- `app_service_sku` - App Service plan size

## Security

- App Service uses managed identity
- Key Vault integration for secrets
- VNet integration for network isolation
- Private endpoints for storage

## TODO


## CI/CD

GitHub Actions workflow included for automated deployment. Set up these secrets:
- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET` 
- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`