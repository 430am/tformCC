resource "azurerm_storage_account" "vm_boot_diag" {
    account_replication_type = "LRS"
    account_tier = "Standard"
    location = azurerm_resource_group.resource_group.location
    name = "sa${random_string.resource_naming.result}bd"
    resource_group_name = azurerm_resource_group.resource_group.name
    
}

data "cloudinit_config" "cc_vm_cloudinit" {
  gzip = false
  base64_encode = true

  part {
    filename = "./scripts/cyclecloud.yaml"
    content_type = "text/cloud-config"
    content = templatefile(var.cyclecloud_cloud_init, {
      cyclecloud_admin_name = var.cc_username
      cyclecloud_admin_password = var.cc_password
      cyclecloud_admin_public_key = chomp(azapi_resource_action.ssh_public_key_gen.output.publicKey)
      cyclecloud_rg = azurerm_resource_group.resource_group.name
      cyclecloud_location = azurerm_resource_group.resource_group.location
      cyclecloud_storage_account = azurerm_storage_account.cc_storage.name
      cyclecloud_storage_container = azurerm_storage_container.name
    })
  }
}

resource "azurerm_linux_virtual_machine" "cc_tf_vm" {
    admin_username = var.cc_username
    location = azurerm_resource_group.resource_group.location
    name = "vm-${random_string.resource_naming.result}-cc"
    network_interface_ids = [ azurerm_network_interface.cc_tf_nic.id ]
    resource_group_name = azurerm_resource_group.resource_group.name
    size = var.cc_vm_sku
    computer_name = var.cc_hostname

    identity {
      type = "SystemAssigned"
    }
    
    source_image_reference {
      publisher = "Canonical"
      offer = "0001-com-ubuntu-server-jammy"
      sku = "22_04-lts-gen2"
      version = "latest"
    }

    os_disk {
        name = "vmOSDisk"
        caching = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    admin_ssh_key {
      username = var.cc_username
      public_key = azapi_resource_action.ssh_public_key_gen.output.publicKey
    }

    boot_diagnostics {
      storage_account_uri = azurerm_storage_account.vm_boot_diag.primary_blob_endpoint
    }
    
}

resource "azurerm_network_interface" "cc_tf_nic" {
    location = azurerm_resource_group.network_rg.location
    name = "nic${random_string.resource_naming.result}-cc"
    resource_group_name = azurerm_resource_group.resource_group.name
    ip_configuration {
        name = "cc${random_string.resource_naming.result}-config"
        private_ip_address_allocation = "Dynamic"
        subnet_id = azurerm_subnet.defaultsubnet.id
        public_ip_address_id = azurerm_public_ip.cc_public_ip.id
    }
}

resource "azurerm_public_ip" "cc_public_ip" {
    allocation_method = "Dynamic"
    location = azurerm_resource_group.resource_group.location
    name = "pip-${random_string.resource_naming.result}"
    resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_network_security_group" "cc_vm_nsg" {
    location = azurerm_resource_group.resource_group.location
    name = "nsg-vm${random_string.resource_naming.result}"
    resource_group_name = azurerm_resource_group.resource_group.name
    
    security_rule = [ {
      name = "SSH_In"
      priority = 1001
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range = "*"
      destination_port_range = "22"
      source_address_prefix = "*"
      destination_address_prefix = "*"
    } ]
}

resource "azurerm_network_interface_security_group_association" "cc_nsg_assoc" {
    network_interface_id = azurerm_network_interface.cc_tf_nic.id
    network_security_group_id = azurerm_network_security_group.cc_vm_nsg.id
    
}