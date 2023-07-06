resource "azurerm_resource_group" "Kubernetes" {
   name = "ling-K8s-terraform"
   location = var.location
}

# Create (and display) an SSH key
resource "tls_private_key" "SSH" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
#### 2 Workers VM
 resource "azurerm_linux_virtual_machine" "test" {
    count                 = 2
    name                  = "Worker${count.index[1]}"
    location              = azurerm_resource_group.Kubernetes.location
    resource_group_name   = azurerm_resource_group.Kubernetes.name
    size                  = "Standard_D2ds_v4"
    network_interface_ids = [
     azurerm_network_interface.test["${count.index[1]}"].id
    ]

    source_image_reference  {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts-gen2"
      version   = "latest"
    }

    computer_name                   = "kub-worker-${count.index[1]}"
    admin_username                  = "ling"
    disable_password_authentication = true

    admin_ssh_key {
      username   = "ling"
      public_key = tls_private_key.SSH.public_key_openssh
   }

    os_disk {
      name = "OSdisk${count.index}"
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
}

 resource "azurerm_linux_virtual_machine" "Manager" {
    name                  = "Manager"
    location              = azurerm_resource_group.Kubernetes.location
    resource_group_name   = azurerm_resource_group.Kubernetes.name
    size                  = "Standard_D2ds_v4"
    network_interface_ids = [
     azurerm_network_interface.test["${2}"].id
     ]

    source_image_reference {
     publisher = "Canonical"
     offer     = "0001-com-ubuntu-server-jammy"
     sku       = "22_04-lts-gen2"
     version   = "latest"
    }

    computer_name                   = "kub-manager"
    admin_username                  = "ling"
    disable_password_authentication = true

    admin_ssh_key {
     username   = "ling"
     public_key = tls_private_key.SSH.public_key_openssh
    }

    os_disk {
      name = "OSdisk"
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    depends_on = [azurerm_resource_group.Kubernetes]
}