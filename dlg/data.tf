data "aws_region" "current" {}

data "aws_ami" "fa-sftp-ec2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-*_HVM_GA-*"]
  }

  filter {
    name   = "description"
    values = ["Provided by Red Hat, Inc."]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
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
    values = ["james.lucktaylor.subnet.a"]
  }
}

data "aws_secretsmanager_secret" "fa-sftp-ec2" {
  name = "fa-sftp-ec2"
}
