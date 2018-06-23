terraform {
  required_version = ">= 0.11.7"

  backend "s3" {
    acl            = "private"
    bucket         = "james-lucktaylor-terraform"
    dynamodb_table = "james.lucktaylor.terraform"
    encrypt        = true
    key            = "projects/px1021/iam/terraform.tfstate" # TODO: remove this 'key', as it is derived dynamically by my init script
  }
}

provider "aws" {
  alias               = "cloudreach-celab"
  allowed_account_ids = ["580501780015"]   # Cloudreach sandbox account
  region              = "${var.region}"
}

provider "aws" {
  alias               = "tidal-auth"
  allowed_account_ids = ["111867032258"]
  region              = "${var.region}"
}

provider "aws" {
  alias               = "tidal-billing"
  allowed_account_ids = ["757202111367"]
  region              = "${var.region}"
}

provider "aws" {
  alias               = "tidal-bo"
  allowed_account_ids = ["498346215557"]
  region              = "${var.region}"
}

provider "aws" {
  alias               = "tidal-dev"
  allowed_account_ids = [""]            # New account that doesn't exist yet?
  region              = "${var.region}"
}

provider "aws" {
  alias               = "tidal-prod-ba"
  allowed_account_ids = ["502656652708"] # Same as below; which is which?
  region              = "${var.region}"
}

provider "aws" {
  alias               = "tidal-prod-play"
  allowed_account_ids = ["502656652708"]  # Same as above; which is which?
  region              = "${var.region}"
}

provider "aws" {
  alias               = "tidal-stg-ba"
  allowed_account_ids = ["692930846239"] # Same as below; which is which?
  region              = "${var.region}"
}

provider "aws" {
  alias               = "tidal-stg-play"
  allowed_account_ids = ["692930846239"] # Same as above; which is which?
  region              = "${var.region}"
}
