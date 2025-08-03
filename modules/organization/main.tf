# modules/organization.tf

resource "github_organization_settings" "main" {
  # Basic org metadata
  billing_email    = var.organization_settings.billing_email
  company          = var.organization_settings.company
  blog             = var.organization_settings.blog
  email            = var.organization_settings.email
  twitter_username = var.organization_settings.twitter_username
  location         = var.organization_settings.location
  name             = var.organization_settings.name
  description      = var.organization_settings.description

  # Project settings
  has_organization_projects = var.organization_settings.has_organization_projects
  has_repository_projects   = var.organization_settings.has_repository_projects

  # Default permission for members
  default_repository_permission = var.organization_settings.default_repository_permission

  # Member repository creation permissions
  members_can_create_repositories          = var.organization_settings.members_can_create_repositories
  members_can_create_public_repositories   = var.organization_settings.members_can_create_public_repositories
  members_can_create_private_repositories  = var.organization_settings.members_can_create_private_repositories
  members_can_create_internal_repositories = var.organization_settings.members_can_create_internal_repositories
  members_can_create_pages                 = var.organization_settings.members_can_create_pages
  members_can_create_public_pages          = var.organization_settings.members_can_create_public_pages
  members_can_create_private_pages         = var.organization_settings.members_can_create_private_pages
  members_can_fork_private_repositories    = var.organization_settings.members_can_fork_private_repositories

  # Web commit signoff
  web_commit_signoff_required = var.organization_settings.web_commit_signoff_required

  # Security features for new repos
  advanced_security_enabled_for_new_repositories               = var.organization_settings.advanced_security_enabled_for_new_repositories
  dependabot_alerts_enabled_for_new_repositories               = var.organization_settings.dependabot_alerts_enabled_for_new_repositories
  dependabot_security_updates_enabled_for_new_repositories     = var.organization_settings.dependabot_security_updates_enabled_for_new_repositories
  dependency_graph_enabled_for_new_repositories                = var.organization_settings.dependency_graph_enabled_for_new_repositories
  secret_scanning_enabled_for_new_repositories                 = var.organization_settings.secret_scanning_enabled_for_new_repositories
  secret_scanning_push_protection_enabled_for_new_repositories = var.organization_settings.secret_scanning_push_protection_enabled_for_new_repositories
}

# Organization security manager - assign admin team as security managers
resource "github_organization_security_manager" "security_manager_team" {
  team_slug = var.security_manager_team_slug
}


