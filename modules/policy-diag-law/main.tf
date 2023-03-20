# Azure policy assignment
resource "azurerm_resource_group_policy_assignment" "policy_assignment" {
  name                 = "policy-assignment"
  depends_on = [
    azurerm_policy_set_definition.policy_set,
    azurerm_log_analytics_workspace.law
  ]
  lifecycle {
    replace_triggered_by = [
      azurerm_policy_set_definition.policy_set
    ]
  }
  resource_group_id    = azurerm_resource_group.rg.id
  location             = azurerm_resource_group.rg.location
  policy_definition_id = azurerm_policy_set_definition.policy_set.id
  enforce              = true
  identity {
    type = "SystemAssigned"
  }
}