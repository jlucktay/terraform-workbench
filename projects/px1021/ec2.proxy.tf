resource "aws_instance" "teleport-proxy" {
  ami                         = "${data.aws_ami.amazon-linux-latest.image_id}"
  associate_public_ip_address = true
  count                       = 1
  instance_type               = "t2.micro"
  key_name                    = "james.lucktaylor.${data.aws_region.current.name}"
  subnet_id                   = "${element(data.aws_subnet_ids.main.ids, count.index)}"
  user_data                   = "${data.template_file.user-data.rendered}"

  tags = "${
    merge(
      local.default-tags,
      map(
        "Name", "james.lucktaylor.teleport-proxy.${count.index}",
        "StopDaily", "Yes",
      )
    )
  }"

  vpc_security_group_ids = [
    "${data.aws_security_group.default.id}",
    "${data.aws_security_group.dmz.id}",
    "${aws_security_group.teleport-proxy.id}",
  ]

  lifecycle {
    ignore_changes = [
      "tags.%",
      "tags.Created",
    ]
  }
}

data "template_file" "user-data" {
  template = "${file("${path.module}/ec2.teleport-proxy.user-data.sh")}"

  # vars {
  #   teleport_yaml = "${data.template_file.teleport-yaml.rendered}"
  # }
}

# data "template_file" "teleport-yaml" {
#   template = "${file("${path.module}/teleport.yaml")}"
# }


# data "template_cloudinit_config" "user-data" {
#   base64_encode = false
#   gzip          = false
#
#   part {
#     content = "${data.template_file.user-data.rendered}"
#   }
# }
