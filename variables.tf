variable "environment" {
  description = "Environmental options"
  type        = object({
    project_name = string
  })
}
  
variable "region" {
  description = "Azure region"
  type        = string
}

variable "policy_set" {
  description = "Azure Policy Initiative Options"
  type = object(
    {
      name                  = string # Policy Set Name
      display_name          = string # Policy Set Display Name
      description           = string # Policy Set Description
      management_group_name = string # Managment Group Name where definition is created
    }
  )
}

variable "policy_definition_reference" {
  description = "List of built-in Azure Policy definition(s) to add to policy set"
  type = list(string)
}