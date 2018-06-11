resource "aws_dynamodb_table" "state-locking-consistency" {
  hash_key       = "LockID"
  name           = "james.lucktaylor.terraform"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }
}
