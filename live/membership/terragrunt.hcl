include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../modules/membership"
}

locals {
  # Load JSON files from current directory
  organization_members = jsondecode(file("${get_terragrunt_dir()}/members.json"))
  teams                = jsondecode(file("${get_terragrunt_dir()}/teams.json"))

  # Load team members dynamically
  team_member_files = fileset("${get_terragrunt_dir()}/team-members", "*.json")
  team_members = flatten([
    for file_name in local.team_member_files :
    jsondecode(file("${get_terragrunt_dir()}/team-members/${file_name}"))
  ])
}

inputs = {
  organization_members = local.organization_members
  teams                = local.teams
  team_members         = local.team_members
}