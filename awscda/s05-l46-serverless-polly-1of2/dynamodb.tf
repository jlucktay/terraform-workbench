resource "aws_dynamodb_table" "posts" {
  hash_key       = "id"
  name           = "james.lucktaylor.polly.posts"
  read_capacity  = 1
  write_capacity = 1

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james.lucktaylor.posts",
    )
  )}"

  attribute {
    name = "id"
    type = "S"
  }
}
