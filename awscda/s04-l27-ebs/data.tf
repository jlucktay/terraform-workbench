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

data "aws_subnet" "main-a" {
  filter {
    name   = "tag:Name"
    values = ["james.lucktaylor.subnet.a.public"]
  }
}
