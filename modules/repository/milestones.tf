# modules/repository/milestones.tf 

resource "github_repository_milestone" "all" {
  for_each = {
    for item in flatten([
      for repo_name, _ in var.repositories : [
        for milestone in var.milestones : {
          key         = "${repo_name}:${milestone.title}"
          repository  = repo_name
          title       = milestone.title
          description = milestone.description
          due_date    = milestone.due_date
          state       = milestone.state
        }
      ]
    ]) : item.key => item
  }

  owner       = var.organization_name
  repository  = github_repository.all[each.value.repository].name
  title       = each.value.title
  description = each.value.description
  due_date    = each.value.due_date
  state       = each.value.state
}
