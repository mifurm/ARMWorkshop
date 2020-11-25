resource "azurerm_virtual_network" "vnet-lab-we-lab-10_247_0_0__16" {
  name                = "vnet-lab-we-lab-10_247_0_0__16"
  location            = azurerm_resource_group.rg-prod-ec.location
  resource_group_name = azurerm_resource_group.rg-prod-ec.name
  address_space       = var.vnet
  tags                = {
        "Department"  = ""
        "Company"     = ""
    }
}
