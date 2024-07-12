terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.98.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.30.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.3"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config[0].host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config[0].client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config[0].cluster_ca_certificate)
}
