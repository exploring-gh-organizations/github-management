# live/root.hcl - Root configuration

# Configure remote state (local for now)
remote_state {
  backend = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    path = "${path_relative_to_include()}/terraform.tfstate"
  }
}

# Generate common variables for all modules
generate "common_vars" {
  path = "common_vars.tf" 
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
  default     = "${get_env("GITHUB_TOKEN")}"
}

variable "github_owner" {
  description = "GitHub organization or owner name" 
  type        = string
  default     = "exploring-gh-organizations"
}
EOF
}

# Generate provider configuration
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "github" {
  token = var.github_token
  owner = var.github_owner
}
EOF
}