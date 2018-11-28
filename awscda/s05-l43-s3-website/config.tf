terraform {
  backend "s3" {
    acl     = "private"
    encrypt = true
  }
}

provider "aws" {
  region = "${var.region}"
}
