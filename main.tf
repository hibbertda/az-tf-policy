
locals {
  rg_name = "rg-${var.environment.project_name}-${var.region}"
  sa_name = "sac3b7bopse${var.region}"
}

# Azure resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-law-poltest"
  location = var.region
}

# data get management group
data "azurerm_management_group" "mg" {
  name = var.policy_set.management_group_name
}

module "log_analytics_workspace" {
  source          = "./modules/law"
  resource_group  = azurerm_resource_group.rg
}

# Create Azure Storage Account
resource "azurerm_storage_account" "storage_account" {
  name                     = local.sa_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

# # create azure policy initiative
# resource "azurerm_policy_set_definition" "policy_set" {
#   name                = var.policy_set.name
#   policy_type         = "Custom"
#   display_name        = var.policy_set.display_name
#   description         = var.policy_set.description
#   management_group_id = data.azurerm_management_group.mg.id

#   dynamic "policy_definition_reference" {
#     for_each = toset(var.policy_definition_reference)
#     content {
#     policy_definition_id = policy_definition_reference.value
#     parameter_values = jsonencode({
#       "logAnalytics" = {
#         value = module.log_analytics_workspace.id
#       }
#     })
#     }
#   }
# }

# Azure policy assignment
# resource "azurerm_resource_group_policy_assignment" "policy_assignment" {
#   name                 = "policy-assignment"
#   depends_on = [
#     azurerm_policy_set_definition.policy_set,
#     module.log_analytics_workspace
#   ]
#   lifecycle {
#     replace_triggered_by = [
#       azurerm_policy_set_definition.policy_set
#     ]
#   }
#   resource_group_id    = azurerm_resource_group.rg.id
#   location             = azurerm_resource_group.rg.location
#   policy_definition_id = azurerm_policy_set_definition.policy_set.id
#   enforce              = true
#   identity {
#     type = "SystemAssigned"
#   }
# }

module "custom_policy_definitions" {
  source = "./modules/custom_policy_definitions"
  management_group = data.azurerm_management_group.mg.id
}

module "policy-set" {
  # lifecycle {
  #   replace_triggered_by = [
  #     module.custom_policy_definitions
  #   ]
  # }    
  source = "./modules/policy_set"

  policy_set        = var.policy_set
  policy_definition = module.custom_policy_definitions
  management_group  = data.azurerm_management_group.mg.id
}

output "test" {
  value = module.custom_policy_definitions
}



 