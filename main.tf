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

resource "azurerm_storage_account" "cc_storage" {
    account_replication_type = "LRS"
    account_tier = "Standard"
    location = azurerm_resource_group.resource_group.location
    name = "st${random_string.resource_naming.result}cc"
    resource_group_name = azurerm_resource_group.resource_group.name
    access_tier = "Hot"
    account_kind = "StorageV2"
    is_hns_enabled = false
}

resource "azurerm_storage_container" "cc_container" {
    name = "store${random_string.resource_naming.result}"
    storage_account_name = azurerm_storage_account.cc_storage.name
    container_access_type = "private"
}