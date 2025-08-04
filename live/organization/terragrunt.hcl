include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../modules/organization"
}

dependency "membership" {
  config_path = "../membership"
  mock_outputs = {
    teams = {}
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan", "validate"]
}

dependency "repositories" {
  config_path = "../repository"
  mock_outputs = {
    repositories = {}
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan", "validate"]
}

locals {
  # Load JSON files from current directory
  organization_settings = jsondecode(file("${get_terragrunt_dir()}/organization.json"))
  rulesets              = jsondecode(file("${get_terragrunt_dir()}/rulesets.json"))
}

inputs = {
  organization_settings      = local.organization_settings
  rulesets                   = local.rulesets
  security_manager_team_slug = "admin"
  github_teams               = dependency.membership.outputs.teams
}