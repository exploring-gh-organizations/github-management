# modules/management/outputs.tf

output "teams" {
  description = "Created teams with their IDs and slugs"
  value = {
    for team_slug, team in github_team.all : team_slug => {
      id            = team.id
      slug          = team.slug
      name          = team.name
      description   = team.description
      privacy       = team.privacy
      node_id       = team.node_id
      members_count = team.members_count
    }
  }
}

output "organization_members" {
  description = "Organization members"
  value = {
    for username, membership in github_membership.all : username => {
      username = membership.username
      role     = membership.role
    }
  }
}

output "team_memberships" {
  description = "Team membership details"
  value = {
    for key, membership in github_team_membership.members : key => {
      team_id  = membership.team_id
      username = membership.username
      role     = membership.role
    }
  }
}

# output "current_user" {
#   description = "Current authenticated user information"
#   value = {
#     username = data.github_user.self.login
#     name     = data.github_user.self.name
#     email    = data.github_user.self.email
#   }
# }
