locals {
  definitionID = {
      for key, value in var.policy_definition:
      key => value
  }
  }


# Azure policy set definition
resource "azurerm_policy_set_definition" "policy_set" {
  name                = var.policy_set.name
  policy_type         = "Custom"
  display_name        = var.policy_set.display_name
  description         = var.policy_set.description
  management_group_id = var.management_group

  metadata = jsonencode({
    category = "Network Security"
  })
  parameters = jsonencode(
    {
      logsEnabled = {
        type         = "String"
        metadata = {
          displayName = "Logs Enabled"
          description = "Enable or disable logging"
        }
        defaultValue = "true"
        allowedValues = [
          "true",
          "false",
        ]
      }
      storageaccount = {
        type         = "String"
        metadata = {
          displayName = "Storage Account ID"
          description = "Resource ID for the destination Storage Account"
        }
      }
      # profileName = {
      #   type = "String"
      #   metadata = {
      #     displayName = "Profile Name"
      #     description = "Name of the profile to be used for diagnostic settings"
      #   }
      #   #defaultValue = "default"
      # }    
    })

  dynamic "policy_definition_reference" {
    for_each = local.definitionID
    content{
      policy_definition_id = policy_definition_reference.value
      parameter_values = jsonencode({
        logsEnabled = {
          value = "[parameters('logsEnabled')]"
          metadata = {
            displayName = "Logs Enabled"
            description = "Enable or disable logging"
          }
          allowedValues = [
            "true",
            "false",
          ]
          defaultValue = "true"
          }
        storageaccount = {
          value = "[parameters('storageaccount')]"
          metadata = {
            displayName = "Storage Account ID"
            description = "Resource ID for the destination Storage Account"
          }
        profileName = {
          value = "[parameters('profileName')]"
          metadata = {
            displayName = "Profile Name"
            description = "Name of the profile to be used for diagnostic settings"
          }
          }
        effect = {
          metadata = {
            displayName = "Effect"
            description = "Enable or disable the execution of the policy"
          }
          allowedValues = [
            "DeployIfNotExists",
            "Disabled",
          ]
          value = "DeployIfNotExists"
        }
      }
    })
    }
  }
}