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
  allowed_account_ids = ["580501780015"] # Cloudreach sandbox # TODO: update this; maybe split providers by account?
  region              = "${var.region}"
}
