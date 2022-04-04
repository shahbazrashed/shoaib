output "azure_subnet_id" {
    value = azurerm_subnet.Bastian-Subnet.id
}

output "bastion_pubip" {
  value = azurerm_public_ip.bastion_pubip.ip_address
  description = "List the public IP of the bastion server"
}