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

  name        = each.value.ruleset_name
  repository  = github_repository.all[each.value.repository].name
  target      = each.value.ruleset_config.target
  enforcement = each.value.ruleset_config.enforcement

  conditions {
    ref_name {
      include = each.value.ruleset_config.target_branches
      exclude = []
    }
  }

  # Team bypasses (using repository roles)
  dynamic "bypass_actors" {
    for_each = each.value.ruleset_config.bypass_teams
    content {
      actor_id    = 5 # Repository admin role
      actor_type  = "RepositoryRole"
      bypass_mode = "pull_request"
    }
  }

  rules {
    creation                = each.value.ruleset_config.rules.block_creations
    deletion                = !each.value.ruleset_config.rules.allow_deletions
    required_signatures     = each.value.ruleset_config.rules.required_signatures
    required_linear_history = each.value.ruleset_config.rules.required_linear_history
    non_fast_forward        = !each.value.ruleset_config.rules.allow_force_pushes

    dynamic "pull_request" {
      for_each = each.value.ruleset_config.rules.pull_request != null ? [each.value.ruleset_config.rules.pull_request] : []
      content {
        required_approving_review_count   = pull_request.value.required_approvals
        dismiss_stale_reviews_on_push     = pull_request.value.dismiss_stale_reviews
        require_code_owner_review         = pull_request.value.require_code_owner_review
        require_last_push_approval        = pull_request.value.require_last_push_approval
        required_review_thread_resolution = pull_request.value.required_review_thread_resolution
      }
    }

    dynamic "required_status_checks" {
      for_each = length(each.value.ruleset_config.rules.required_status_checks) > 0 ? [1] : []
      content {
        strict_required_status_checks_policy = true
        dynamic "required_check" {
          for_each = each.value.ruleset_config.rules.required_status_checks
          content {
            context = required_check.value.context
          }
        }
      }
    }
  }
}
