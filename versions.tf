terraform {
  required_providers {
    azurerm = {
      source  = "registry.terraform.io/hashicorp/azurerm"
      version = "< 5.15"
    }
  }
  required_version = ">=1.4"
}
