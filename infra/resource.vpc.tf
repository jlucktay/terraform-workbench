# resource "aws_default_vpc" "main" {}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name_prefix}.vpc"
  }
}
