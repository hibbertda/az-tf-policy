locals {
  law_name = "law-diag-${var.resource_group.location}"
}

# Azure log analytics workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = local.law_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

output "id" {
  value = azurerm_log_analytics_workspace.law.id
}
