terraform {
  required_version = ">= 0.11.7"

  backend "s3" {
    acl     = "private"
    bucket  = "james-lucktaylor-terraform"
    encrypt = true
    key     = "terraform.tfstate"
    region  = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}
