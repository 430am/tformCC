// Networking infratructure

resource "azurerm_virtual_network" "hub" {
    address_space = var.hub_vnet_address_space
    location = azurerm_resource_group.resource_group.location
    name = "vnet-hub${random_string.resource_naming.result}"
    resource_group_name = azurerm_resource_group.resource_group.name
    tags = azurerm_resource_group.network.tags
}

resource "azurerm_subnet" "defaultsubnet" {
    depends_on = [ azurerm_virtual_network.hub ]
    address_prefixes = [ "172.16.0.0/24" ]
    name = "subnet0-default"
    resource_group_name = azurerm_resource_group.resource_group.name
    virtual_network_name = azurerm_virtual_network.hub.name    
}
