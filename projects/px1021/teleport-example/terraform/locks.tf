// Locks is a dynamodb table used as a distributed lock to make sure there is only one auth server doing letsencrypt certificate renewal, this is not critical for teleport and is purely for demonstration purposes
resource "aws_dynamodb_table" "locks" {
  hash_key       = "Lock"
  name           = "${var.cluster_name}-locks"
  read_capacity  = 10
  tags           = "${local.default_tags}"
  write_capacity = 10

  attribute {
    name = "Lock"
    type = "S"
  }

  ttl {
    attribute_name = "Expires"
    enabled        = true
  }
}
