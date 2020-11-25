provider "azurerm" {
    subscription_id= "c3f53507-8081-4ebe-8d1b-40e4816b6162"
    tenant_id="680a6956-d4bd-4da5-a6f4-ca743607f394"
    version = "=2.30.0"
    features {}
}

variable "location" {
    default = "West Europe"
}
