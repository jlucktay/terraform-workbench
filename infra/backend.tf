terraform {
  backend "s3" {
    acl     = "private"
    encrypt = true
    key     = "infra/terraform.tfstate"
  }
}
