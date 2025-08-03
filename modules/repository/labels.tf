# modules/repository/labels.tf 


resource "github_issue_label" "all" {
  for_each = {
    for item in flatten([
      for repo_name, _ in var.repositories : [
        for label in var.labels : {
          key         = "${repo_name}:${label.name}"
          repository  = repo_name
          name        = label.name
          color       = label.color
          description = label.description
        }
      ]
    ]) : item.key => item
  }

  repository  = github_repository.all[each.value.repository].name
  name        = each.value.name
  color       = each.value.color
  description = each.value.description
}
