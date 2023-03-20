environment = {
  project_name = "diag_policy"
}

region = "centralus"

policy_set = {
  description           = "Policy Initiative for Diagnostic Settings"
  display_name          = "TFDiagPolicy2"
  management_group_name = "coeart"
  name                  = "TFDiagPolicy2"
} 

policy_definition_reference = [
  "/providers/Microsoft.Authorization/policyDefinitions/6b359d8f-f88d-4052-aa7c-32015963ecc1",
  "/providers/Microsoft.Authorization/policyDefinitions/c717fb0c-d118-4c43-ab3d-ece30ac81fb3",
  "/providers/Microsoft.Authorization/policyDefinitions/2465583e-4e78-4c15-b6be-a36cbc7c8b0f" # Azure Activity Logs
]