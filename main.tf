resource "azurerm_public_ip" "public_ip" {
  name                = "devops-20201175" 
  resource_group_name = data.azurerm_resource_group.tp4.name
  location            = "francecentral"
  allocation_method   = "Dynamic"

}
 


resource "azurerm_network_interface" "main" {
  name                = "devops-20201175" 
  resource_group_name = data.azurerm_resource_group.tp4.name
  location            = "francecentral"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = data.azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id

  }
}

resource "tls_private_key" "rsa-4096-example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "azurerm_linux_virtual_machine" "example" {
  name                = "devops-20201175"
  resource_group_name = data.azurerm_resource_group.tp4.name
  location            = "francecentral"
  size                = "Standard_D2s_v3"
  admin_username      = "devops"
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  admin_ssh_key {
    username   = "devops"
    public_key = tls_private_key.rsa-4096-example.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}