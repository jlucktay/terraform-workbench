// Bastion is an emergency access bastion that could be spun up on demand in case of need to have emergency administrative access
resource "aws_instance" "bastion" {
  ami                         = "${data.aws_ami.base.id}"
  associate_public_ip_address = true
  count                       = "1"
  instance_type               = "t2.medium"
  key_name                    = "${var.key_name}"
  source_dest_check           = false
  subnet_id                   = "${element(aws_subnet.public.*.id, 0)}"

  tags = "${merge(
    local.default_tags,
    map(
      "Name", "james.lucktaylor.teleport.bastion",
      "StopDaily", "No",
      "TeleportRole", "bastion",
    )
  )}"

  vpc_security_group_ids = [
    "${aws_security_group.bastion.id}",
  ]
}

// Bastions are open to internet access
resource "aws_security_group" "bastion" {
  name   = "${var.cluster_name}-bastion"
  tags   = "${local.default_tags}"
  vpc_id = "${local.vpc_id}"
}

// Ingress traffic is allowed to SSH 22 port only
resource "aws_security_group_rule" "bastion_ingress_allow_ssh" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bastion.id}"
  to_port           = 22
  type              = "ingress"

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

// Egress traffic is allowed everywhere
resource "aws_security_group_rule" "proxy_egress_bastion_all_traffic" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.bastion.id}"
  to_port           = 0
  type              = "egress"

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}
