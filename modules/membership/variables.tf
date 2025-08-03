variable "organization_members" {
  description = "Teams to create in the organization"
  type = map(object({
    username = string
    role     = string
  }))
}

variable "teams" {
  description = "Teams to create in the organization"
  type = map(object({
    description = optional(string, "")
    privacy     = optional(string, "closed")
  }))
}

variable "team_members" {
  description = "List of team members with their roles and team slugs"
  type = list(object({
    team_slug = string
    username  = string
    role      = string
  }))
}

