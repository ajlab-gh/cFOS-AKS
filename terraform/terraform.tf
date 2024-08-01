terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.112.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.4"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
    git = {
      source = "paultyng/git"
      version = "0.1.0"
    }
  }
}

provider "azurerm" {
  features {
    api_management {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted         = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "git" {}
