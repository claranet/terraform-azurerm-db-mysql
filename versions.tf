terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.23"
    }
    mysql = {
      source  = "winebarrel/mysql"
      version = ">=1.10.4"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0"
    }
  }
}
