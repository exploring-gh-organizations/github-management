# modules/membership-management/main.tf

# Create organization members
resource "github_membership" "all" {
  for_each = {
    for member in var.organization_members :
    member.username => member
  }

  username = each.value.username
  role     = each.value.role
}

# Create Teams
resource "github_team" "all" {
  for_each = var.teams

  name        = each.key
  description = each.value.description
  privacy     = each.value.privacy
}

# Assign members to teams
resource "github_team_membership" "members" {
  for_each = {
    for tm in var.team_members : "${tm.team_slug}:${tm.username}" => tm
  }

  team_id  = github_team.all[each.value.team_slug].id
  username = each.value.username
  role     = each.value.role
}

