# modules/repository/rulesets.tf

resource "github_repository_ruleset" "repo_rulesets" {
  for_each = {
    for item in flatten([
      for repo_name, repo_config in var.repositories : [
        for ruleset_name, ruleset_config in var.rulesets : {
          key            = "${repo_name}:${ruleset_name}"
          repository     = repo_name
          ruleset_name   = ruleset_name
          ruleset_config = ruleset_config
        }
        if contains(ruleset_config.repository_names, repo_name)
      ]
    ]) : item.key => item
  }

  name        = each.value.ruleset_config.name
  repository  = github_repository.all[each.value.repository].name
  target      = each.value.ruleset_config.target
  enforcement = each.value.ruleset_config.enforcement

  conditions {
    ref_name {
      include = each.value.ruleset_config.target_branches
      exclude = []
    }
  }

  # Organization admin bypass
  bypass_actors {
    actor_id    = 1
    actor_type  = "OrganizationAdmin"
    bypass_mode = "always"
  }

  # Repository admin bypass
  dynamic "bypass_actors" {
    for_each = each.value.ruleset_config.bypass_teams
    content {
      actor_id    = 5 # Repository admin role
      actor_type  = "RepositoryRole"
      bypass_mode = "pull_request"
    }
  }

  rules {
    # Basic protection rules
    creation                      = each.value.ruleset_config.rules.creation
    deletion                      = each.value.ruleset_config.rules.deletion
    update                        = each.value.ruleset_config.rules.update
    non_fast_forward              = each.value.ruleset_config.rules.non_fast_forward
    required_linear_history       = each.value.ruleset_config.rules.required_linear_history
    required_signatures           = each.value.ruleset_config.rules.required_signatures
    update_allows_fetch_and_merge = each.value.ruleset_config.rules.update_allows_fetch_and_merge

    # Pull request rules
    dynamic "pull_request" {
      for_each = each.value.ruleset_config.rules.pull_request != null ? [each.value.ruleset_config.rules.pull_request] : []
      content {
        required_approving_review_count   = pull_request.value.required_approving_review_count
        dismiss_stale_reviews_on_push     = pull_request.value.dismiss_stale_reviews_on_push
        require_code_owner_review         = pull_request.value.require_code_owner_review
        require_last_push_approval        = pull_request.value.require_last_push_approval
        required_review_thread_resolution = pull_request.value.required_review_thread_resolution
      }
    }

    # Required status checks
    dynamic "required_status_checks" {
      for_each = each.value.ruleset_config.rules.required_status_checks != null ? [each.value.ruleset_config.rules.required_status_checks] : []
      content {
        strict_required_status_checks_policy = required_status_checks.value.strict_required_status_checks_policy
        do_not_enforce_on_create             = required_status_checks.value.do_not_enforce_on_create

        dynamic "required_check" {
          for_each = required_status_checks.value.required_check
          content {
            context        = required_check.value.context
            integration_id = required_check.value.integration_id
          }
        }
      }
    }

    # Required code scanning
    dynamic "required_code_scanning" {
      for_each = each.value.ruleset_config.rules.required_code_scanning != null ? [each.value.ruleset_config.rules.required_code_scanning] : []
      content {
        dynamic "required_code_scanning_tool" {
          for_each = required_code_scanning.value.required_code_scanning_tool
          content {
            tool                      = required_code_scanning_tool.value.tool
            alerts_threshold          = required_code_scanning_tool.value.alerts_threshold
            security_alerts_threshold = required_code_scanning_tool.value.security_alerts_threshold
          }
        }
      }
    }

    # Required deployments
    dynamic "required_deployments" {
      for_each = each.value.ruleset_config.rules.required_deployments != null ? [each.value.ruleset_config.rules.required_deployments] : []
      content {
        required_deployment_environments = required_deployments.value.required_deployment_environments
      }
    }

    # Merge queue
    dynamic "merge_queue" {
      for_each = each.value.ruleset_config.rules.merge_queue != null ? [each.value.ruleset_config.rules.merge_queue] : []
      content {
        check_response_timeout_minutes    = merge_queue.value.check_response_timeout_minutes
        grouping_strategy                 = merge_queue.value.grouping_strategy
        max_entries_to_build              = merge_queue.value.max_entries_to_build
        max_entries_to_merge              = merge_queue.value.max_entries_to_merge
        merge_method                      = merge_queue.value.merge_method
        min_entries_to_merge              = merge_queue.value.min_entries_to_merge
        min_entries_to_merge_wait_minutes = merge_queue.value.min_entries_to_merge_wait_minutes
      }
    }

    # Branch name pattern (Enterprise only)
    dynamic "branch_name_pattern" {
      for_each = each.value.ruleset_config.rules.branch_name_pattern != null ? [each.value.ruleset_config.rules.branch_name_pattern] : []
      content {
        name     = branch_name_pattern.value.name
        operator = branch_name_pattern.value.operator
        pattern  = branch_name_pattern.value.pattern
        negate   = branch_name_pattern.value.negate
      }
    }

    # Commit message pattern (Enterprise only)
    dynamic "commit_message_pattern" {
      for_each = each.value.ruleset_config.rules.commit_message_pattern != null ? [each.value.ruleset_config.rules.commit_message_pattern] : []
      content {
        name     = commit_message_pattern.value.name
        operator = commit_message_pattern.value.operator
        pattern  = commit_message_pattern.value.pattern
        negate   = commit_message_pattern.value.negate
      }
    }

    # Commit author email pattern (Enterprise only)
    dynamic "commit_author_email_pattern" {
      for_each = each.value.ruleset_config.rules.commit_author_email_pattern != null ? [each.value.ruleset_config.rules.commit_author_email_pattern] : []
      content {
        name     = commit_author_email_pattern.value.name
        operator = commit_author_email_pattern.value.operator
        pattern  = commit_author_email_pattern.value.pattern
        negate   = commit_author_email_pattern.value.negate
      }
    }

    # Committer email pattern (Enterprise only)
    dynamic "committer_email_pattern" {
      for_each = each.value.ruleset_config.rules.committer_email_pattern != null ? [each.value.ruleset_config.rules.committer_email_pattern] : []
      content {
        name     = committer_email_pattern.value.name
        operator = committer_email_pattern.value.operator
        pattern  = committer_email_pattern.value.pattern
        negate   = committer_email_pattern.value.negate
      }
    }

    # Tag name pattern (Enterprise only)  
    dynamic "tag_name_pattern" {
      for_each = each.value.ruleset_config.rules.tag_name_pattern != null ? [each.value.ruleset_config.rules.tag_name_pattern] : []
      content {
        name     = tag_name_pattern.value.name
        operator = tag_name_pattern.value.operator
        pattern  = tag_name_pattern.value.pattern
        negate   = tag_name_pattern.value.negate
      }
    }
  }
}
