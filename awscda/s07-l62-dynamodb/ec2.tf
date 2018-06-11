resource "aws_instance" "awscda-dyndb" {
  ami                         = "${data.aws_ami.amazon-linux-latest.image_id}"
  associate_public_ip_address = true
  count                       = 1
  iam_instance_profile        = "${aws_iam_instance_profile.ec2-dyndb.name}"
  instance_type               = "t2.micro"
  key_name                    = "james.lucktaylor.${data.aws_region.current.name}"
  subnet_id                   = "${data.aws_subnet.main-a.id}"
  user_data                   = "${data.template_file.user-data.rendered}"

  tags = "${
    merge(
      local.default-tags,
      map(
        "Name", "james.lucktaylor.ec2.awscda.dyndb.${count.index}",
        "StopDaily", "Yes",
      )
    )
  }"

  vpc_security_group_ids = [
    "${data.aws_security_group.dmz.id}",
  ]

  lifecycle {
    ignore_changes = [
      "tags.%",
      "tags.Created",
    ]
  }
}

data "template_file" "user-data" {
  template = "${file("${path.module}/ec2.awscda.dyndb.userdata.sh")}"

  vars {}
}
