variable "hub_vnet_address_space" {
    description = "List of address spaces for the hub virtual network. One /24 address is expected."
    type = list(string)
    default = [ "172.16.0.0/20" ]
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

variable "cc_username" {
  description = "username for the local account that will be created on the CycleCloud server"
  type = string
  default = "azureadmin"
}

variable "cc_hostname" {
  description = "hostname of the CycleCloud server"
  type = string
  default = "CycleCloudSrv"
}

variable "cc_vm_sku" {
  description = "Azure SKU size of the CycleCloud VM"
  type = string
  default = "Standard_D4as_v5"
}

variable "cc_password" {
}

variable "cyclecloud_cloud_init" {
  description = "path to cloud-init user data to pass to the VM"
  type = string
  default = "./scripts/user-data.yaml.tpl"
}