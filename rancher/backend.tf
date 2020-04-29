terraform {
  backend "s3" {
    acl     = "private"
    encrypt = true
    key     = "rancher/terraform.tfstate"
  }
}
