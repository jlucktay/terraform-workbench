resource "aws_default_security_group" "main" {
  revoke_rules_on_delete = true
  vpc_id                 = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}.sg.default"
  }

  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 0
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "-1"
    to_port          = 0
  }

  ingress {
    from_port = 0
    protocol  = -1
    self      = true
    to_port   = 0
  }
}
