resource "github_branch_protection" "main" {
  count = length(github_repository.tyk)

  repository     = github_repository.tyk[count.index].name
  branch         = "master"
  enforce_admins = true

  require_signed_commits = false

  required_status_checks {
    strict   = true
    contexts = ["ci/travis"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    dismissal_users                 = []
    dismissal_teams                 = []
    require_code_owner_reviews      = true
    required_approving_review_count = 1
  }
}
