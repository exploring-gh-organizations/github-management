# modules/organization/rulesets.tf

resource "github_organization_ruleset" "all" {
  for_each = length(var.rulesets) > 0 ? var.rulesets : {}

  name        = each.key
  target      = each.value.target
  enforcement = each.value.enforcement

  conditions {
    ref_name {
      include = each.value.target_branches
      exclude = []
    }

    repository_name {
      include = each.value.repository_names
      exclude = []
    }
  }

  # Owner bypass
  bypass_actors {
    actor_id    = 1
    actor_type  = "OrganizationAdmin"
    bypass_mode = "always"
  }

  # Team bypasses
  dynamic "bypass_actors" {
    for_each = each.value.bypass_teams
    content {
      actor_id    = var.github_teams[bypass_actors.value].id
      actor_type  = "Team"
      bypass_mode = "pull_request"
    }
  }

  rules {
    # Basic rules
    creation                = each.value.rules.block_creations
    update                  = false
    deletion                = !each.value.rules.allow_deletions
    required_signatures     = each.value.rules.required_signatures
    required_linear_history = each.value.rules.required_linear_history
    non_fast_forward        = !each.value.rules.allow_force_pushes

    # Pull request rules
    dynamic "pull_request" {
      for_each = each.value.rules.pull_request != null ? [each.value.rules.pull_request] : []
      content {
        required_approving_review_count   = pull_request.value.required_approvals
        dismiss_stale_reviews_on_push     = pull_request.value.dismiss_stale_reviews
        require_code_owner_review         = pull_request.value.require_code_owner_review
        require_last_push_approval        = pull_request.value.require_last_push_approval
        required_review_thread_resolution = pull_request.value.required_review_thread_resolution
      }
    }

    # Required status checks
    dynamic "required_status_checks" {
      for_each = length(each.value.rules.required_status_checks) > 0 ? [1] : []
      content {
        strict_required_status_checks_policy = true

        dynamic "required_check" {
          for_each = each.value.rules.required_status_checks
          content {
            context        = required_check.value.context
            integration_id = required_check.value.integration_id
          }
        }
      }
    }

    # Required workflows - handle both auto-enable and explicit definitions
    dynamic "required_workflows" {
      for_each = (length(each.value.rules.required_workflows) > 0) ? [1] : []
      content {
        # Add any explicitly defined workflows
        dynamic "required_workflow" {
          for_each = each.value.rules.required_workflows
          content {
            repository_id = try(
              required_workflow.value.repository_id,
              github_repository.all[required_workflow.value.repository].repo_id
            )
            path = required_workflow.value.path
            ref  = required_workflow.value.ref
          }
        }
      }
    }

    # Required code scanning
    dynamic "required_code_scanning" {
      for_each = length(each.value.rules.required_code_scanning) > 0 ? [1] : []
      content {
        dynamic "required_code_scanning_tool" {
          for_each = each.value.rules.required_code_scanning
          content {
            tool                      = required_code_scanning_tool.value.tool
            alerts_threshold          = required_code_scanning_tool.value.alerts_threshold
            security_alerts_threshold = required_code_scanning_tool.value.security_alerts_threshold
          }
        }
      }
    }

    # Commit message pattern
    dynamic "commit_message_pattern" {
      for_each = each.value.rules.commit_message_pattern != null ? [each.value.rules.commit_message_pattern] : []
      content {
        name     = commit_message_pattern.value.name
        operator = commit_message_pattern.value.operator
        pattern  = commit_message_pattern.value.pattern
        negate   = commit_message_pattern.value.negate
      }
    }

    # Branch name pattern
    dynamic "branch_name_pattern" {
      for_each = each.value.rules.branch_name_pattern != null ? [each.value.rules.branch_name_pattern] : []
      content {
        name     = branch_name_pattern.value.name
        operator = branch_name_pattern.value.operator
        pattern  = branch_name_pattern.value.pattern
        negate   = branch_name_pattern.value.negate
      }
    }
  }
}


