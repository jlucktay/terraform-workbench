resource "aws_instance" "fa-sftp-ec2" {
  ami                         = "${data.aws_ami.fa-sftp-ec2.id}"
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.fa-sftp-ec2.name}"
  instance_type               = "t2.micro"
  key_name                    = "james.lucktaylor.${data.aws_region.current.name}"
  monitoring                  = true
  subnet_id                   = "${data.aws_subnet.main-a.id}"
  user_data                   = "${file("ec2.sftp.user-data.sh")}"

  depends_on = [
    "data.aws_secretsmanager_secret.fa-sftp-ec2",
  ]

  tags = "${
    merge(
      local.default-tags,
      map(
        "Name", "james.lucktaylor.ec2.fa-sftp",
        "StopDaily", "Yes",
      )
    )
  }"

  volume_tags = "${
    merge(
      local.default-tags,
      map(
        "Name", "james.lucktaylor.ec2.fa-sftp.sda",
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
      "volume_tags.%",
      "volume_tags.Created",
      "volume_tags.ParentInstance",
    ]
  }
}

resource "aws_ebs_volume" "gp2" {
  availability_zone = "${aws_instance.fa-sftp-ec2.availability_zone}"
  size              = 100
  type              = "gp2"

  tags = "${
    merge(
      local.default-tags,
      map(
        "Name", "james.lucktaylor.ec2.fa-sftp.sdb"
      )
    )
  }"

  lifecycle {
    ignore_changes = [
      "tags.%",
      "tags.Created",
      "tags.ParentInstance",
    ]
  }
}

resource "aws_volume_attachment" "gp2" {
  device_name  = "/dev/sdb"
  force_detach = true
  instance_id  = "${aws_instance.fa-sftp-ec2.id}"
  skip_destroy = false
  volume_id    = "${aws_ebs_volume.gp2.id}"
}
