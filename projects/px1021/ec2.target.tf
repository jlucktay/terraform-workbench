resource "aws_instance" "teleport-target" {
  ami                         = "${data.aws_ami.amazon-linux-latest.image_id}"
  associate_public_ip_address = false
  count                       = 1
  instance_type               = "t2.micro"
  key_name                    = "james.lucktaylor.${data.aws_region.current.name}"
  subnet_id                   = "${element(data.aws_subnet_ids.public.ids, count.index)}"
  user_data                   = "${data.template_file.user-data.rendered}"

  tags = "${
    merge(
      local.default-tags,
      map(
        "Name", "james.lucktaylor.teleport-target.${count.index}",
        "StopDaily", "Yes",
      )
    )
  }"

  vpc_security_group_ids = [
    "${data.aws_security_group.default.id}",
  ]

  lifecycle {
    ignore_changes = [
      "tags.%",
      "tags.Created",
    ]
  }
}

data "template_file" "user-data" {
  template = "${file("${path.module}/ec2.teleport-target.user-data.sh")}"
}
