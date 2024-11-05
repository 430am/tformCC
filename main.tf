resource "random_string" "resource_naming" {
    length = 7
    special = false
    upper = false
    lower = true
    numeric = true
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "resource_group" {
    location = var.location
    name = "rg-${random_string.resource_naming.result}-net"
    tags = var.tags
}