# modules/organization/outputs.tf

output "organization" {
  description = "Organization settings and information"
  value = {
    name                                    = github_organization_settings.main.name
    description                             = github_organization_settings.main.description
    billing_email                           = github_organization_settings.main.billing_email
    email                                   = github_organization_settings.main.email
    blog                                    = github_organization_settings.main.blog
    location                                = github_organization_settings.main.location
    default_repository_permission           = github_organization_settings.main.default_repository_permission
    has_organization_projects               = github_organization_settings.main.has_organization_projects
    dependency_graph_enabled                = github_organization_settings.main.dependency_graph_enabled_for_new_repositories
    dependabot_alerts_enabled               = github_organization_settings.main.dependabot_alerts_enabled_for_new_repositories
    dependabot_security_updates_enabled     = github_organization_settings.main.dependabot_security_updates_enabled_for_new_repositories
    secret_scanning_enabled                 = github_organization_settings.main.secret_scanning_enabled_for_new_repositories
    secret_scanning_push_protection_enabled = github_organization_settings.main.secret_scanning_push_protection_enabled_for_new_repositories
    advanced_security_enabled               = github_organization_settings.main.advanced_security_enabled_for_new_repositories
    web_commit_signoff_required             = github_organization_settings.main.web_commit_signoff_required
  }
}

# output "rulesets" {
#   description = "All dynamically created organization rulesets"
#   value = {
#     for key, rs in github_organization_ruleset.all :
#     key => {
#       id          = rs.ruleset_id
#       name        = rs.name
#       target      = rs.target
#       enforcement = rs.enforcement
#     }
#   }
# }

output "security_manager" {
  description = "Security manager team information"
  value = {
    team_slug = github_organization_security_manager.security_manager_team.team_slug
  }
}
