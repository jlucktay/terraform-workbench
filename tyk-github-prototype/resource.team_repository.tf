resource "github_team_repository" "one" {
  team_id    = github_team.one.id
  repository = github_repository.tyk[0].name
  permission = "admin"
}

resource "github_team_repository" "two" {
  team_id    = github_team.two.id
  repository = github_repository.tyk[1].name
  permission = "admin"
}

resource "github_team_repository" "three" {
  team_id    = github_team.three.id
  repository = github_repository.tyk[2].name
  permission = "admin"
}
