resource "aws_instance" "teleport-target" {
  ami                         = "${data.aws_ami.amazon-linux-latest.image_id}"
  associate_public_ip_address = true
  count                       = 1
  instance_type               = "t2.micro"
  key_name                    = "james.lucktaylor.${data.aws_region.current.name}"
  subnet_id                   = "${element(data.aws_subnet_ids.public.ids, count.index)}"
  user_data                   = "${data.template_file.teleport-target-user-data.rendered}"

  tags = "${
    merge(
      local.default-tags,
      map(
        "Name", "james.lucktaylor.teleport-target.${count.index}",
        "Purpose", "Client PoC/demo",
        "StopDaily", "No",
      )
    )
  }"

  vpc_security_group_ids = [
    "${data.aws_security_group.default.id}",
    "${data.aws_security_group.dmz.id}",
  ]

  lifecycle {
    ignore_changes = [
      "tags.%",
      "tags.Created",
      "user_data",
    ]
  }
}

data "template_file" "teleport-target-user-data" {
  template = "${file("${path.module}/ec2.teleport-target.user-data.sh")}"
}
