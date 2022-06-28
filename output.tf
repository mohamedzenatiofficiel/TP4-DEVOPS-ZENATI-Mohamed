output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}
output "tls_private_key" {
  value = tls_private_key.rsa-4096-example.private_key_pem
  sensitive=true
}