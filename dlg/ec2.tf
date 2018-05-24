resource "aws_instance" "fa-sftp-ec2" {
  ami                         = "${data.aws_ami.fa-sftp-ec2.id}"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = "james.lucktaylor.${data.aws_region.current.name}"
  monitoring                  = true
  subnet_id                   = "${data.aws_subnet.main-a.id}"
  user_data                   = "${file("ec2.sftp.user-data.sh")}"

  lifecycle {
    ignore_changes = [
      "tags.%",
      "tags.Created",

      # "user_data",
      "volume_tags.%",

      "volume_tags.Created",
      "volume_tags.ParentInstance",
    ]
  }

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
}

resource "aws_ebs_volume" "gp2" {
  availability_zone = "${aws_instance.fa-sftp-ec2.availability_zone}"
  size              = 100
  type              = "gp2"

  lifecycle {
    ignore_changes = [
      "tags.%",
      "tags.Created",
      "tags.ParentInstance",
    ]
  }

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james.lucktaylor.ec2.fa-sftp.sdb"
    )
  )}"
}

resource "aws_volume_attachment" "gp2" {
  device_name  = "/dev/sdb"
  force_detach = true
  instance_id  = "${aws_instance.fa-sftp-ec2.id}"
  skip_destroy = false
  volume_id    = "${aws_ebs_volume.gp2.id}"
}
