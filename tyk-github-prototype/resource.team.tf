resource "github_team" "one" {
  name        = "Team 1"
  description = "First tier team"
  privacy     = "closed"
}

resource "github_team" "two" {
  name           = "Team 2"
  description    = "Second tier team"
  parent_team_id = github_team.one.id
  privacy        = "closed"
}

resource "github_team" "three" {
  name           = "Team 3"
  description    = "Third tier team"
  parent_team_id = github_team.two.id
  privacy        = "closed"
}
