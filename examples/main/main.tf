terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0.0"
    }
    mysql = {
      source  = "Paynetworx/mysql"
      version = "~> 1.12"
    }
  }
}

provider "azurerm" {
  features {}
}
