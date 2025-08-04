include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../modules/repository"
}

dependency "membership" {
  config_path = "../membership"
  mock_outputs = {
    teams = {}
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan", "validate"]
}

locals {
  # Load JSON files from current directory
  repositories = jsondecode(file("${get_terragrunt_dir()}/repositories.json"))
  rulesets     = jsondecode(file("${get_terragrunt_dir()}/rulesets.json"))
  labels       = jsondecode(file("${get_terragrunt_dir()}/labels.json"))
  milestones   = jsondecode(file("${get_terragrunt_dir()}/milestones.json"))
}

inputs = {
  repositories       = local.repositories
  rulesets           = local.rulesets
  labels             = local.labels
  milestones         = local.milestones
  organization_teams = dependency.membership.outputs.teams
  organization_name  = "exploring-gh-organizations"
}