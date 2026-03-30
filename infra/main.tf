terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
     resource_group_name  = "rg-tfstate-dev"
     storage_account_name = "stfinbanktf"
     container_name       = "tfstate"
     key                  = "terraform.tfstate"
   }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.project}-${var.env}-rg"
  location = var.location
}

# Key Vault
resource "azurerm_key_vault" "kv" {
  name                        = "${var.project}${var.env}kv12345"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
}

# Log Analytics
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.project}-${var.env}-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Action Group
resource "azurerm_monitor_action_group" "ag" {
  name                = "${var.project}-${var.env}-ag"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "finAG"

  email_receiver {
    name          = "alert-email"
    email_address = var.alert_email
  }
}