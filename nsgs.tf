#############################################################################
# Network security Groups
#############################################################################

locals {
  ports         = [443,3389,1433] # A rule will be created for each of these ports
  bastian_ports = [3389,443] # Separate list of ports for bastian NSG as unlike others, the source is from internet
}

#############################################################################
# Database NSG
#############################################################################

resource "azurerm_network_security_group" "Dbase-SG" {
  name                = "Dabase-SG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = local.ports 
    content {
      name                       = "inbound-rule-${security_rule.key}"
      description                = "Inbound Rule ${security_rule.key}"    
      priority                   = sum([100, security_rule.key])
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"      
    }
  }
 
  security_rule {
    name                       = "Outbound-rule-1"
    description                = "Outbound Rule"    
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }    
}

#############################################################################
# Database NSG association with Database subnet
#############################################################################


resource "azurerm_subnet_network_security_group_association" "dbaseassociate" {
  subnet_id                 = azurerm_subnet.dbase-Subnet.id
  network_security_group_id = azurerm_network_security_group.Dbase-SG.id
}

#############################################################################
# Application NSG
#############################################################################


resource "azurerm_network_security_group" "App-SG" {
  name                = "App-SG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = local.ports 
    content {
      name                       = "inbound-rule-${security_rule.value}"
      description                = "Inbound Rule ${security_rule.key}"    
      priority                   = sum([100, security_rule.key])
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"      
    }
  }
 
  security_rule {
    name                       = "Outbound-rule-1"
    description                = "Outbound Rule"    
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }    
security_rule {
    name                       = "Inbount 443 from internet"
    description                = "Inbount 443 from internet"    
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "443"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }    

}
#############################################################################
# Application NSG Association with App subnet
#############################################################################

resource "azurerm_subnet_network_security_group_association" "Appasociate" {
  subnet_id                 = azurerm_subnet.App-Subnet.id
  network_security_group_id = azurerm_network_security_group.App-SG.id
}
#############################################################################
# Bastian NSG
#############################################################################
resource "azurerm_network_security_group" "Bastian-SG" {
  name                = "Bastian-SG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = local.bastian_ports 
    content {
      name                       = "inbound-rule-${security_rule.key}"
      description                = "Inbound Rule ${security_rule.key}"    
      priority                   = sum([100, security_rule.key])
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"      
    }
  }
 
  security_rule {
    name                       = "Outbound-rule-1"
    description                = "Outbound Rule"    
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }    
}
#############################################################################
# Bastian  NSG association with Bastian Subnet
#############################################################################

resource "azurerm_subnet_network_security_group_association" "bastassociate" {
  subnet_id                 = azurerm_subnet.Bastian-Subnet.id
  network_security_group_id = azurerm_network_security_group.Bastian-SG.id
}