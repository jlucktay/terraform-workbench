resource "aws_security_group" "dmz" {
  description            = "DMZ with access to ports 22, 80, 443 from anywhere"
  name                   = "${local.name_prefix}.sg.dmz"
  revoke_rules_on_delete = true
  vpc_id                 = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}.sg.dmz"
  }
}

resource "aws_security_group_rule" "dmz-allow-ssh-from-everywhere-ipv4" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "SSH from everywhere - IPv4"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.dmz.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "dmz-allow-ssh-from-everywhere-ipv6" {
  description       = "SSH from everywhere - IPv6"
  from_port         = 22
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.dmz.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "dmz-allow-http-from-everywhere-ipv4" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "HTTP from everywhere - IPv4"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.dmz.id
  to_port           = 80
  type              = "ingress"
}

resource "aws_security_group_rule" "dmz-allow-http-from-everywhere-ipv6" {
  description       = "HTTP from everywhere - IPv6"
  from_port         = 80
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.dmz.id
  to_port           = 80
  type              = "ingress"
}

resource "aws_security_group_rule" "dmz-allow-https-from-everywhere-ipv4" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "HTTPS from everywhere - IPv4"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.dmz.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "dmz-allow-https-from-everywhere-ipv6" {
  description       = "HTTPS from everywhere - IPv6"
  from_port         = 443
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.dmz.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "dmz-allow-all-to-everywhere-ipv4" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "All to everywhere - IPv4"
  from_port         = -1
  protocol          = "all"
  security_group_id = aws_security_group.dmz.id
  to_port           = -1
  type              = "egress"
}

resource "aws_security_group_rule" "dmz-allow-all-to-everywhere-ipv6" {
  description       = "All to everywhere - IPv6"
  from_port         = -1
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "all"
  security_group_id = aws_security_group.dmz.id
  to_port           = -1
  type              = "egress"
}
