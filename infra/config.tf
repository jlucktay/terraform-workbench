terraform {
  backend "s3" {
    acl            = "private"
    bucket         = "${var.state_bucket}"
    dynamodb_table = "${var.state_dynamodb}"
    encrypt        = true
  }
}

provider "aws" {
  region = "${var.region}"
}
