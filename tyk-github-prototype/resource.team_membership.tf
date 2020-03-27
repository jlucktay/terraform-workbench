resource "github_team_membership" "one" {
  role     = "maintainer"
  team_id  = github_team.one.id
  username = data.github_user.me.login
}

resource "github_team_membership" "two" {
  role     = "maintainer"
  team_id  = github_team.two.id
  username = data.github_user.me.login
}

resource "github_team_membership" "three" {
  role     = "maintainer"
  team_id  = github_team.three.id
  username = data.github_user.me.login
}
