
# modules/repository/variables.tf

variable "organization_name" {
  description = "GitHub organization name"
  type        = string
}

variable "organization_teams" {
  description = "Teams defied in the organization"
  type = map(object({
    id   = number
    slug = string
  }))
  default = {}
}

variable "repositories" {
  description = "Repository configurations"
  type = map(object({
    # Repository collaborators
    collaborating_teams = optional(map(string), {})

    # Basic config
    description = string
    visibility  = optional(string, "private")
    topics      = optional(list(string), [])

    # Feature flags
    has_issues      = optional(bool, true)
    has_wiki        = optional(bool, false)
    has_discussions = optional(bool, false)
    has_downloads   = optional(bool, false)
    has_projects    = optional(bool, false)

    # Init & settings
    auto_init              = optional(bool, true)
    delete_branch_on_merge = optional(bool, true)
    allow_update_branch    = optional(bool, true)
    vulnerability_alerts   = optional(bool, true)
    archive_on_destroy     = optional(bool, false)

    # Merge settings
    allow_merge_commit = optional(bool, true)
    allow_squash_merge = optional(bool, true)
    allow_rebase_merge = optional(bool, true)
    allow_auto_merge   = optional(bool, true)

    # Optional templates
    gitignore_template = optional(string)
    license_template   = optional(string)

    # URL / homepage
    homepage_url = optional(string)

    # GitHub Pages
    pages = optional(object({
      build_type = optional(string, "workflow")
      cname      = optional(string)
      source = optional(object({
        branch = string
        path   = optional(string, "/")
      }))
    }))
  }))
}

variable "labels" {
  description = "GitHub labels to create in all repositories"
  type = list(object({
    name        = string
    color       = string
    description = optional(string)
  }))
  default = []
}

variable "milestones" {
  description = "GitHub milestones to create in all repositories"
  type = list(object({
    title       = string
    description = optional(string)
    due_date    = optional(string)
    state       = optional(string, "open")
  }))
  default = []
}

variable "rulesets" {
  description = "Repository-level ruleset configurations"
  type = map(object({
    name             = string
    target           = optional(string, "branch")
    enforcement      = optional(string, "active")
    target_branches  = optional(list(string), ["~DEFAULT_BRANCH"])
    repository_names = list(string)
    bypass_teams     = optional(list(string), [])

    rules = object({
      # Basic rules
      creation                      = optional(bool, false)
      deletion                      = optional(bool, false)
      update                        = optional(bool, false)
      non_fast_forward              = optional(bool, true)
      required_linear_history       = optional(bool, false)
      required_signatures           = optional(bool, false)
      update_allows_fetch_and_merge = optional(bool, false)

      # Pull request rules
      pull_request = optional(object({
        required_approving_review_count   = optional(number, 1)
        dismiss_stale_reviews_on_push     = optional(bool, true)
        require_code_owner_review         = optional(bool, false)
        require_last_push_approval        = optional(bool, false)
        required_review_thread_resolution = optional(bool, true)
      }))

      # Status checks
      required_status_checks = optional(object({
        strict_required_status_checks_policy = optional(bool, true)
        do_not_enforce_on_create             = optional(bool, false)
        required_check = list(object({
          context        = string
          integration_id = optional(number)
        }))
      }))

      # Code scanning
      required_code_scanning = optional(object({
        required_code_scanning_tool = list(object({
          tool                      = string
          alerts_threshold          = string
          security_alerts_threshold = string
        }))
      }))

      # Deployment environments
      required_deployments = optional(object({
        required_deployment_environments = list(string)
      }))

      # Merge queue
      merge_queue = optional(object({
        check_response_timeout_minutes    = optional(number, 60)
        grouping_strategy                 = optional(string, "ALLGREEN")
        max_entries_to_build              = optional(number, 5)
        max_entries_to_merge              = optional(number, 5)
        merge_method                      = optional(string, "MERGE")
        min_entries_to_merge              = optional(number, 1)
        min_entries_to_merge_wait_minutes = optional(number, 5)
      }))

      # Patterns (Enterprise features - may not work on free tier)
      branch_name_pattern = optional(object({
        name     = optional(string)
        operator = string
        pattern  = string
        negate   = optional(bool, false)
      }))

      commit_message_pattern = optional(object({
        name     = optional(string)
        operator = string
        pattern  = string
        negate   = optional(bool, false)
      }))

      commit_author_email_pattern = optional(object({
        name     = optional(string)
        operator = string
        pattern  = string
        negate   = optional(bool, false)
      }))

      committer_email_pattern = optional(object({
        name     = optional(string)
        operator = string
        pattern  = string
        negate   = optional(bool, false)
      }))

      tag_name_pattern = optional(object({
        name     = optional(string)
        operator = string
        pattern  = string
        negate   = optional(bool, false)
      }))
    })
  }))
  default = {}
}

