resource "github_repository" "tyk" {
  count = 3

  name         = format("tyk-example-%d", count.index)
  description  = "Tyk prototype with Terraform's GitHub provider"
  homepage_url = "https://tyk.io"

  private = false

  has_issues   = true
  has_projects = true
  has_wiki     = true

  allow_merge_commit = false
  allow_rebase_merge = false
  allow_squash_merge = true

  archived      = false
  auto_init     = false
  has_downloads = false

  topics = [
    "github",
    "prototype",
    "terraform",
    "tyk"
  ]

  # template {
  #   owner      = "github"
  #   repository = "terraform-module-template"
  # }

  # gitignore_template
  #  - (Optional) Use the name of the template without the extension. For example, "Haskell".

  # license_template
  #  - (Optional) Use the name of the template without the extension. For example, "mit" or "mpl-2.0".

  # default_branch
  #  - (Optional) The name of the default branch of the repository.
  # NOTE: This can only be set after a repository has already been created, and after a correct reference has been
  # created for the target branch inside the repository.
  # This means a user will have to omit this parameter from the initial repository creation and create the target
  # branch inside of the repository prior to setting this attribute.
}
