# Azure policy definition azure firewall diagnostic settings
resource "azurerm_policy_definition" "azure_firewall_diagnostic_settings" {
  name                = "azure-keyvault-diagnostic-settings"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "TF - Azure Key Vault Diagnostic Settings - Storage Account"
  description         = "This policy ensures that Azure Key vault diagnostic settings are configured."
  management_group_id = var.management_group

  metadata     = jsonencode({
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
        allowedValues = [
          "true",
          "false",
        ]
        defaultValue = "true"
      }
      storageaccount = {
        type         = "String"
        metadata = {
          displayName = "Storage Account ID"
          description = "Resource ID for the destination Storage Account"
        }
      }
      profileName = {
        type = "String"
        metadata = {
          displayName = "Profile Name"
          description = "Name of the profile to be used for diagnostic settings"
        }
        defaultValue = "M2131setbypolicy"
      }
      effect = {
        type         = "string"
        defaultValue = "DeployIfNotExists"
        allowedValues = [
          "DeployIfNotExists",
          "Disabled",
        ]
        metadata = {
          displayName = "Effect"
          description = "Enable or disable the execution of the policy"
        }
      }
    }
  )
  policy_rule = jsonencode(
    {
      if = {
        field  = "type"
        Equals = "Microsoft.KeyVault/vaults"
      }
      then = {
        effect  = "[parameters('effect')]"
        details = {
          type = "Microsoft.Authorization/policyDefinitions"
          deployment = {
            properties = {
              mode = "Incremental"
              parameters = {
                location = {
                  value = "[field('location')]"
                  }
                logsEnabled = {
                  value = "[parameters('logsEnabled')]"
                  }
                profileName = {
                  value = "[parameters('profileName')]"
                  }
                storageaccount = {
                  value = "[parameters('storageaccount')]"
                  }
                }
              template = {
                "$schema" = "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#"
                contentVersion = "1.0.0.0"
                outputs = {}
                parameters = {
                  location = {
                    type = "string"
                    }
                  logsEnabled = {
                    type = "array"
                    }
                  profileName = {
                    type = "string"
                    }
                  storageaccount = {
                    type = "string"
                    }
                  }
                resources = {
                  name = "[concat(parameters('resourceName'), '/', 'Microsoft.Insights/', parameters('profileName'))]"
                  type = "Microsoft.KeyVault/vaults/providers/diagnosticSettings"
                  apiVersion = "2017-05-01-preview"
                  location = "[parameters('location')]"
                  properties = {
                    storageAccountId = "[parameters('storageaccount')]"
                    logs             = [
                      {
                        "category": "AuditEvent",
                        "enabled": "[parameters('logsEnabled')]"
                      },
                      {
                        "category": "AzurePolicyEvaluationDetails",
                        "enabled": "[parameters('logsEnabled')]"
                      }
                    ]
                  }
                }
              }
            }
          }
        }
      }
    }
  )
}


output "azkv" {
  value = azurerm_policy_definition.azure_keyvault_diagnostic_settings.id
}