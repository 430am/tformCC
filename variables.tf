variable "hub_vnet_address_space" {
    description = "List of address spaces for the hub virtual network. One /24 address is expected."
    type = list(string)
    default = [ "172.16.0.0/20" ]
}

variable "spoke_vnet_address_space" {
    description = "List of address spaces for the spoke virtual network. One /24 address space is expected."
    type = list(string)
    default = [ "172.16.16.0/16" ]
}

variable "location" {
    default = "eastus2"
}

variable "tags" {
    type = object({
      owner = string
      env = string
      enforce = bool
    })
    default = {
      enforce = null
      env = null
      owner = null
    }
}