terraform {
  required_version = "~> 0.11.7"

  backend "s3" {
    acl            = "private"
    bucket         = "james-lucktaylor-terraform"
    dynamodb_table = "james.lucktaylor.terraform"
    encrypt        = true
  }
}

provider "random" {
  version = "~> 1.3"
}

provider "template" {
  version = "~> 1.0"
}

variable "aws_max_retries" {
  default = 5
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 1.26"
}
