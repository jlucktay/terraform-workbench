terraform {
  required_version = ">= 0.11.7"

  backend "s3" {
    acl            = "private"
    bucket         = "james-lucktaylor-terraform"
    dynamodb_table = "james.lucktaylor.dynamodb.terraform"
    encrypt        = true
  }
}

provider "aws" {
  region = "${var.region}"
}
