resource "aws_sns_topic" "new_posts" {
  display_name = "New Posts"
  name         = "james_lucktaylor_new_posts"

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james_lucktaylor_new_posts",
    )
  )}"
}
