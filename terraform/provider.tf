terraform {
  required_version = ">= 1.9.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.15.0"
    }
  }
}
provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}