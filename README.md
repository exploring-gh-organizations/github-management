<a id="readme-top"></a>

<!-- PROJECT LOGO & TITLE -->

<div align="center">
  <a href="https://github.com/opencloudhub/github-management">
    <img src="https://raw.githubusercontent.com/opencloudhub/.github/main/references/brand/assets/logos/primary-logo-light-background.svg" alt="OpenCloudHub Logo" width="100%" style="max-width:320px;" height="160">
  </a>

<h1 align="center">GitHub Organization Management</h1>

<!-- SORT DESCRIPTION -->

<p align="center">
    Infrastructure as Code for OpenCloudHub GitHub organization, repositories, teams, and security policies.<br />
    <a href="https://github.com/opencloudhub"><strong>Explore the organization »</strong></a>
  </p>

<!-- BADGES -->

<p align="center">
    <a href="https://github.com/opencloudhub/github-management/graphs/contributors">
      <img src="https://img.shields.io/github/contributors/opencloudhub/github-management.svg?style=for-the-badge" alt="Contributors">
    </a>
    <a href="https://github.com/opencloudhub/github-management/network/members">
      <img src="https://img.shields.io/github/forks/opencloudhub/github-management.svg?style=for-the-badge" alt="Forks">
    </a>
    <a href="https://github.com/opencloudhub/github-management/stargazers">
      <img src="https://img.shields.io/github/stars/opencloudhub/github-management.svg?style=for-the-badge" alt="Stars">
    </a>
    <a href="https://github.com/opencloudhub/github-management/issues">
      <img src="https://img.shields.io/github/issues/opencloudhub/github-management.svg?style=for-the-badge" alt="Issues">
    </a>
    <a href="https://github.com/opencloudhub/github-management/blob/main/LICENSE">
      <img src="https://img.shields.io/github/license/opencloudhub/github-management.svg?style=for-the-badge" alt="License">
    </a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->

<details>
  <summary>📑 Table of Contents</summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#features">Features</a></li>
    <li><a href="#getting-started">Getting Started</a></li>
    <li><a href="#project-structure">Project Structure</a></li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#security">Security</a></li>
    <li><a href="#cicd-pipeline">CI/CD Pipeline</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

<h2 id="about-the-project">🏢 About The Project</h2>

This repository contains the Infrastructure as Code (IaC) configuration for managing the OpenCloudHub GitHub organization. It uses Terraform to declaratively define and manage:

- **Organization settings** and security policies
- **Team structure** and membership via CSV files
- **Repository creation** and configuration
- **Branch protection rules** and rulesets
- **Labels and milestones** across all repositories
- **Access controls** and permissions

The configuration supports both the current solo development phase and future team scaling, with comprehensive security controls and automation-ready CI/CD pipelines.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- FEATURES -->

<h2 id="features">✨ Features</h2>

- **🔐 Security-First**: Advanced security features, secret scanning, and vulnerability alerts enabled by default
- **👥 Team Management**: CSV-driven team and membership management for easy scaling
- **📋 Repository Rulesets**: Organization-wide branch protection and security policies
- **🧠 Dynamic Rulesets**: Support for dynamic branch protection with status checks, workflows, and code scanning rules
- **🏷️ Standardized Labels**: Consistent labeling across all repositories
- **🎯 Milestone Tracking**: Automated milestone creation for project management
- **🔄 GitOps Ready**: Designed for automated CI/CD workflows
- **📊 Comprehensive Outputs**: Detailed Terraform outputs for integration with other systems
- **🛡️ Multi-Tier Security**: Different security levels for public, private, and infrastructure repositories

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->

<h2 id="getting-started">🚀 Getting Started</h2>

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.6.0
- [GitHub CLI](https://cli.github.com/) (optional, for secret management)
- GitHub Personal Access Token with organization admin permissions

### Installation & Initial Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/opencloudhub/github-management.git
   cd github-management
   ```

1. **Configure your environment**

   ```bash
   # Set your GitHub token
   export GITHUB_OWNER="exploring-gh-organizations"
   export GITHUB_TOKEN="ghp_XXXXXX"


   # Copy and customize the example variables
   cp live/terraform.tfvars.example live/terraform.tfvars
   ```

1. **Customize team and member data**

   ```bash
   # Edit team structure
   vim live/data/teams.csv

   # Edit organization members
   vim live/data/members.csv

   # Edit team memberships
   vim live/data/team-members/admin.csv
   vim live/data/team-members/platform.csv
   # ... etc
   ```

1. **Initialize and apply Terraform**

   ```bash
   cd live/
   terraform init
   terraform plan
   terraform apply
   ```

5. if you alread have stuff that u wanna start managing do terragrunt import 'github_repository.all[".github"]' .github

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- PROJECT STRUCTURE -->

<h2 id="project-structure">📁 Project Structure</h2>

```
github-management/
├── live/                           # Live configuration and state
│   ├── data/                       # CSV data files for teams and members
│   │   ├── members.csv             # Organization members
│   │   ├── team-members/           # Team membership files
│   │   │   ├── admin.csv           # Admin team members
│   │   │   ├── ai.csv              # AI team members
│   │   │   ├── app.csv             # App team members
│   │   │   └── platform.csv       # Platform team members
│   │   └── teams.csv               # Team definitions
│   ├── labels.tf                   # Organization-wide labels configuration
│   ├── main.tf                     # Main module calls
│   ├── milestones.tf               # Project milestones configuration
│   ├── outputs.tf                  # Output definitions
│   ├── repositories.tf             # Repository configurations
│   ├── terraform.tf                # Terraform and provider configuration
│   ├── terraform.tfvars            # Variable values (customize this)
│   └── variables.tf                # Variable definitions
├── modules/                        # Reusable Terraform modules
│   ├── organization/               # Organization settings and rulesets
│   │   ├── main.tf                 # Organization settings and security
│   │   ├── outputs.tf              # Organization outputs
│   │   ├── providers.tf            # Provider configuration
│   │   ├── repository-rulesets.tf  # Branch protection and security rules
│   │   └── variables.tf            # Organization variables
│   ├── repository/                 # Repository management
│   │   ├── main.tf                 # Repository creation and configuration
│   │   ├── outputs.tf              # Repository outputs
│   │   ├── providers.tf            # Provider configuration
│   │   └── variables.tf            # Repository variables
│   └── team-management/            # Team and membership management
│       ├── main.tf                 # Team creation and membership
│       ├── outputs.tf              # Team outputs
│       ├── providers.tf            # Provider configuration
│       └── variables.tf            # Team variables
├── .github/                        # GitHub Actions workflows
│   └── workflows/                  # CI/CD pipeline definitions
├── .gitignore                      # Ignored files and directories
├── LICENSE                         # License information
└── README.md                       # This file
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE -->

<h2 id="usage">💡 Usage</h2>

### Adding New Team Members

1. **Add to organization members** (if not already added):

   ```csv
   # live/data/members.csv
   username,role
   new-member,member
   ```

1. **Add to specific team**:

   ```csv
   # live/data/team-members/platform.csv
   username,role
   new-member,member
   ```

### Creating New Repositories

1. **Add repository configuration**:
   ```hcl
   # live/repositories.tf (or in local block)
   "new-repo-name" = {
     description = "Description of the new repository"
     visibility  = "public"  # or "private"
     topics      = ["topic1", "topic2"]
     teams = {
       "platform" = "maintain"
       "admin"    = "admin"
     }
   }
   ```

<!-- SECURITY -->

<h2 id="security">🛡️ Security</h2>

This configuration implements multiple layers of security:

### Organization-Level Security

- **Advanced Security** features enabled by default
- **Secret scanning** and push protection
- **Dependency graph** and Dependabot alerts
- **Vulnerability reporting** enabled
- **Web commit signoff** required

### Repository Rulesets

- **Main branch protection** with required status checks
- **High-security ruleset** for infrastructure repositories
- **Required pull requests** with automated checks
- **Dynamic enforcement** of branch protections, status checks, required workflows, and code scanning tools

### Access Control

- **Team-based permissions** with least privilege principle
- **Admin team bypass** capabilities for emergency situations
- **Graduated access levels**: pull → push → maintain → admin

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CICD PIPELINE -->

<h2 id="cicd-pipeline">🔄 CI/CD Pipeline</h2>

The repository includes automated CI/CD workflows:

### Pull Request Workflow

1. **Code Quality Checks** (via reusable workflow from `.github` repo)

   - Pre-commit hooks validation
   - Terraform formatting and validation
   - Security scanning with Trivy and TruffleHog

1. **Terraform Plan**

   - Generates and comments plan on PR
   - Validates all configuration changes

### Main Branch Workflow

1. **Terraform Apply** (on merge to main)
   - Automatically applies approved changes
   - Updates organization configuration

### Workflow Files

- Uses **reusable workflows** from `opencloudhub/.github` repository
- **Shared code quality** checks for consistency

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->

<h2 id="contributing">👥 Contributing</h2>

Contributions are welcome! This project follows established workflows and security practices.

Please see our [Contributing Guidelines](https://github.com/opencloudhub/.github/blob/main/CONTRIBUTING.md) and [Code of Conduct](https://github.com/opencloudhub/.github/blob/main/CODE_OF_CONDUCT.md) for more details.

### Development Workflow

1. **Create feature branch** from main
1. **Make changes** following the project structure
1. **Test locally** with `terraform plan`
1. **Create pull request** - automated checks will run
1. **Review and merge** - changes will be applied automatically

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->

<h2 id="license">📄 License</h2>

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->

<h2 id="contact">📬 Contact</h2>

Reach out at: [support@opencloudhub.io](support@opencloudhub.io)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGEMENTS -->

<h2 id="acknowledgements">🙏 Acknowledgements</h2>

This project builds upon excellent open-source tools and practices:

- [Terraform GitHub Provider](https://registry.terraform.io/providers/integrations/github/latest) - Infrastructure as Code for GitHub
- [GitHub CLI](https://cli.github.com/) - Command-line tool for GitHub operations
- [Terraform Best Practices](https://www.terraform-best-practices.com/) - Configuration guidelines
- [GitHub Security Best Practices](https://github.com/features/security) - Security implementation guidance

<p align="right">(<a href="#readme-top">back to top</a>)</p>

______________________________________________________________________

<div align="center">
  <h3>🌟 OpenCloudHub MLOps Platform</h3>
  <p><em>Building in public • Learning together • Sharing knowledge</em></p>

<div>
    <a href="https://opencloudhub.github.io/docs">
      <img src="https://img.shields.io/badge/Read%20the%20Docs-2596BE?style=for-the-badge&logo=read-the-docs&logoColor=white" alt="Documentation">
    </a>
    <a href="https://github.com/orgs/opencloudhub/discussions">
      <img src="https://img.shields.io/badge/Join%20Discussion-181717?style=for-the-badge&logo=github&logoColor=white" alt="Discussions">
    </a>
    <a href="https://github.com/orgs/opencloudhub/projects">
      <img src="https://img.shields.io/badge/View%20Roadmap-0052CC?style=for-the-badge&logo=jira&logoColor=white" alt="Roadmap">
    </a>
  </div>
</div>
