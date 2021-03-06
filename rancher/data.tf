data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_availability_zones" "available" {}

data "aws_subnet" "public" {
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  count             = length(data.aws_availability_zones.available.names)

  tags = {
    Tier = "Public"
  }
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["jlucktay.vpc"]
  }
}

data "aws_security_group" "dmz" {
  name   = "jlucktay.sg.dmz"
  vpc_id = data.aws_vpc.main.id
}
