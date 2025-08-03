# modules/repositories/main.tf

resource "github_repository" "all" {
  for_each = var.repositories

  name        = each.key
  description = each.value.description
  visibility  = each.value.visibility

  # Features
  has_issues      = each.value.has_issues
  has_wiki        = each.value.has_wiki
  has_discussions = each.value.has_discussions
  has_downloads   = each.value.has_downloads
  has_projects    = each.value.has_projects

  # Templates
  gitignore_template = each.value.gitignore_template
  license_template   = each.value.visibility == "public" ? each.value.license_template : null

  # Settings
  auto_init              = each.value.auto_init
  delete_branch_on_merge = each.value.delete_branch_on_merge
  allow_update_branch    = each.value.allow_update_branch
  vulnerability_alerts   = each.value.vulnerability_alerts
  archive_on_destroy     = each.value.archive_on_destroy

  # Merge settings
  allow_merge_commit          = each.value.allow_merge_commit
  allow_squash_merge          = each.value.allow_squash_merge
  allow_rebase_merge          = each.value.allow_rebase_merge
  allow_auto_merge            = each.value.allow_auto_merge
  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "PR_BODY"

  # Homepage
  homepage_url = each.value.homepage_url

  # Topics
  topics = each.value.topics

  # Pages configuration
  dynamic "pages" {
    for_each = each.value.pages != null ? [each.value.pages] : []
    content {
      build_type = pages.value.build_type
      cname      = pages.value.cname

      dynamic "source" {
        for_each = pages.value.source != null ? [pages.value.source] : []
        content {
          branch = source.value.branch
          path   = source.value.path
        }
      }
    }
  }
}

# -----------------------------
# Authoritative collaborator management
# -----------------------------
resource "github_repository_collaborators" "all" {
  for_each = {
    for repo_name, repo_config in var.repositories :
    repo_name => repo_config
    if length(try(repo_config.collaborating_teams, {})) > 0 || length(try(repo_config.users, {})) > 0
  }

  repository = github_repository.all[each.key].name

  # Team collaborators
  dynamic "team" {
    for_each = try(each.value.collaborating_teams, {})
    content {
      team_id    = var.organization_teams[team.key].slug
      permission = team.value
    }
  }
}
