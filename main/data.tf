data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_ami" "amazon-linux-latest" {
  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }

  most_recent = true
}
