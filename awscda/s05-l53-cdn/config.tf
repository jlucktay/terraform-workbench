terraform {
  required_version = ">= 0.11.7"

  backend "s3" {
    acl            = "private"
    bucket         = "james-lucktaylor-terraform"
    dynamodb_table = "james.lucktaylor.terraform"
    encrypt        = true
  }
}

provider "aws" {
  region = "${var.region}"
}

provider "aws" {
  alias  = "london"
  region = "eu-west-2"
}

provider "aws" {
  alias  = "sydney"
  region = "ap-southeast-2"
}
