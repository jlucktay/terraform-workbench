resource "aws_dynamodb_table" "state-locking-consistency" {
  attribute {
    name = "LockID"
    type = "S"
  }

  hash_key       = "LockID"
  name           = "james.lucktaylor.dynamodb.terraform"
  read_capacity  = 1
  write_capacity = 1
}
