terraform {
  required_version = ">= 0.11.7"

  backend "s3" {
    acl            = "private"
    bucket         = "james-lucktaylor-terraform"
    dynamodb_table = "james.lucktaylor.dynamodb.terraform"
    encrypt        = true
    key            = "awscda/s04-l28-efs/terraform.tfstate"
    region         = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}
