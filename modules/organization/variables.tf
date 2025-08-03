# modules/organization/variables.tf

variable "github_teams" {
  description = "The available teams in githib"
  type = map(object({
    id   = number
    slug = string
  }))
  default = {}
}


variable "organization_settings" {
  description = "Organization-wide settings"
  type = object({
    billing_email                 = string
    company                       = optional(string)
    blog                          = optional(string)
    email                         = optional(string)
    twitter_username              = optional(string)
    location                      = optional(string)
    name                          = optional(string)
    description                   = optional(string)
    has_organization_projects     = optional(bool, true)
    has_repository_projects       = optional(bool, false)
    default_repository_permission = optional(string, "read")

    members_can_create_repositories          = optional(bool, false)
    members_can_create_public_repositories   = optional(bool, false)
    members_can_create_private_repositories  = optional(bool, false)
    members_can_create_internal_repositories = optional(bool, false)
    members_can_create_pages                 = optional(bool, false)
    members_can_create_public_pages          = optional(bool, false)
    members_can_create_private_pages         = optional(bool, false)
    members_can_fork_private_repositories    = optional(bool, false)

    web_commit_signoff_required                                  = optional(bool, false)
    advanced_security_enabled_for_new_repositories               = optional(bool, false)
    dependabot_alerts_enabled_for_new_repositories               = optional(bool, false)
    dependabot_security_updates_enabled_for_new_repositories     = optional(bool, false)
    dependency_graph_enabled_for_new_repositories                = optional(bool, false)
    secret_scanning_enabled_for_new_repositories                 = optional(bool, false)
    secret_scanning_push_protection_enabled_for_new_repositories = optional(bool, false)
  })
}

variable "security_manager_team_slug" {
  description = "GitHub team slug for for security manager ( Could be admin)"
  type        = string
}

variable "rulesets" {
  description = "Organization ruleset configurations"
  type = map(object({
    target           = optional(string, "branch")
    enforcement      = optional(string, "active")
    target_branches  = optional(list(string), ["~DEFAULT_BRANCH"])
    repository_names = list(string)
    bypass_teams     = optional(list(string), [])

    rules = object({
      required_signatures              = optional(bool, false)
      required_linear_history          = optional(bool, false)
      allow_force_pushes               = optional(bool, false)
      allow_deletions                  = optional(bool, false)
      block_creations                  = optional(bool, false)
      required_conversation_resolution = optional(bool, true)

      pull_request = optional(object({
        required_approvals                = optional(number, 1)
        dismiss_stale_reviews             = optional(bool, true)
        require_code_owner_review         = optional(bool, false)
        require_last_push_approval        = optional(bool, false)
        required_review_thread_resolution = optional(bool, true)
      }))

      required_status_checks = optional(list(object({
        context        = string
        integration_id = optional(number)
      })), [])

      required_workflows = optional(list(object({
        repository_id = optional(number)
        repository    = optional(string) # Repo name to look up
        path          = string
        ref           = optional(string, "main")
      })), [])

      required_code_scanning = optional(list(object({
        tool                      = string
        alerts_threshold          = string
        security_alerts_threshold = string
      })), [])

      commit_message_pattern = optional(object({
        name     = optional(string)
        operator = string
        pattern  = string
        negate   = optional(bool, false)
      }))

      branch_name_pattern = optional(object({
        name     = optional(string)
        operator = string
        pattern  = string
        negate   = optional(bool, false)
      }))
    })
  }))
}

