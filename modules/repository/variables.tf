
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
      required_signatures     = optional(bool, false)
      required_linear_history = optional(bool, false)
      allow_force_pushes      = optional(bool, false)
      allow_deletions         = optional(bool, false)
      block_creations         = optional(bool, false)

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
    })
  }))
  default = {}
}

