terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.6.0"
    }
    random = {
        source = "hashicorp/random"
        version = "~> 3.6.3"
    }
    cloudinit = {
        source = "hashicorp/cloudinit"
        version = "~> 2.3.5"
    }
    azuread = {
        source = "hashicorp/azuread"
        version = "~> 2.15.0"
    }
  }
}

provider "azurerm" {
    features {
        resource_group {
          prevent_deletion_if_contains_resources = true
        }
        key_vault {
          // These settings may not be suitable for production key vaults
          recover_soft_deleted_key_vaults = true
          purge_soft_delete_on_destroy = true
        }
    }

    storage_use_azuread = true
}

provider "azuread" {}