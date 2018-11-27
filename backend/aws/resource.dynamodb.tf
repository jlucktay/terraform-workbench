resource "aws_dynamodb_table" "state-locking-consistency" {
  hash_key       = "LockID"
  name           = "jlucktay.terraform.state"
  read_capacity  = 1
  write_capacity = 1

  tags = {
    Name = "jlucktay.terraform.state"
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}
