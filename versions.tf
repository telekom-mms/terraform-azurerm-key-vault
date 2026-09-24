terraform {
  required_providers {
    azurerm = {
      source  = "registry.terraform.io/hashicorp/azurerm"
      version = "< 5.8"
    }
  }
  required_version = ">=1.4"
}
