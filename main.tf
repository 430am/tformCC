resource "random_string" "resource_naming" {
    length = 7
    special = false
    upper = false
    lower = true
    numeric = true
}

resource "azurerm_resource_group" "network" {
    location = var.location
    name = "rg-${random_string.resource_naming.result}"
    tags = var.tags
}
