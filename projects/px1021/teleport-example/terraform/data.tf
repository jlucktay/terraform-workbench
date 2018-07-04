// Base AMI is found by name, users can (and should) supply own AMIs
// the only requirement is systemd installed as all scripts
// are relying on systemd
data "aws_ami" "base" {
  most_recent = true

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["debian-*-gp2-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

// This is to figure account_id used in some IAM rules
data "aws_caller_identity" "current" {}

// Use current region of the credentials in some parts of the script,
// could be as well hardcoded.
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

// Pick first two availability zones in the region
locals {
  azs = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}"]
}

// SSM is picking alias for key to use for encryption in SSM
data "aws_kms_alias" "ssm" {
  name = "${var.kms_alias_name}"
}
