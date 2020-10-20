terraform {
  required_version = ">= 0.12.26"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 1.44"
    }
    mysql = {
      source  = "terraform-providers/mysql"
      version = ">= 1.6"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}
