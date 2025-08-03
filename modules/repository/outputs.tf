# modules/repository/outputs.tf

output "repositories" {
  description = "Created repositories"
  value = {
    for name, repo in github_repository.all : name => {
      id             = repo.repo_id
      name           = repo.name
      full_name      = repo.full_name
      description    = repo.description
      visibility     = repo.visibility
      http_clone_url = repo.http_clone_url
      ssh_clone_url  = repo.ssh_clone_url
      html_url       = repo.html_url
      node_id        = repo.node_id # Useful for rulesets
      topics         = repo.topics
    }
  }
}

output "collaborators" {
  description = "Repository collaborator configurations"
  value = {
    for repo_name, collaborator in github_repository_collaborators.all : repo_name => {
      repository = collaborator.repository
      teams = [
        for team in collaborator.team : {
          team_id    = team.team_id
          permission = team.permission
        }
      ]
    }
  }
}

output "labels" {
  description = "Applied repository labels"
  value = {
    for key, label in github_issue_label.all : key => {
      repository  = label.repository
      name        = label.name
      color       = label.color
      description = label.description
      url         = label.url
    }
  }
}

output "milestones" {
  description = "Applied repository milestones"
  value = {
    for key, milestone in github_repository_milestone.all : key => {
      repository  = milestone.repository
      title       = milestone.title
      description = milestone.description
      due_date    = milestone.due_date
      state       = milestone.state
      number      = milestone.number
    }
  }
}
