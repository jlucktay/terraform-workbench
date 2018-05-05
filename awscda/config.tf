terraform {
  required_version = ">= 0.11.7"

  backend "s3" {
    acl            = "private"
    bucket         = "james-lucktaylor-terraform"
    dynamodb_table = "james.lucktaylor.dynamodb.terraform"
    encrypt        = true
    key            = "awscda/terraform.tfstate"
    region         = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}