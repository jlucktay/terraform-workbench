data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_ami" "amazon-linux-latest" {
  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }

  most_recent = true
}

data "aws_security_group" "dmz" {
  filter {
    name   = "tag:Name"
    values = ["james.lucktaylor.sg.dmz"]
  }
}

data "aws_security_group" "default" {
  filter {
    name   = "tag:Name"
    values = ["james.lucktaylor.sg.default"]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = "${data.aws_vpc.main.id}"

  tags {
    Owner = "james.lucktaylor"
    Tier  = "Public"
  }
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["james.lucktaylor.vpc"]
  }
}
