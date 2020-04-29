resource "aws_dynamodb_table" "state_locking_consistency" {
  hash_key       = "LockID"
  name           = var.state_dynamodb
  read_capacity  = 1
  write_capacity = 1

  tags = {
    Name = "${var.state_dynamodb}"
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}
