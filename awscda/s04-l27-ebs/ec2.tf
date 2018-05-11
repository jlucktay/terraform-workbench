resource "aws_instance" "awscda" {
  ami                         = "${data.aws_ami.amazon-linux-latest.image_id}"
  associate_public_ip_address = true
  availability_zone           = "${element(data.aws_availability_zones.available.names, count.index)}"
  instance_type               = "t2.micro"
  key_name                    = "james.lucktaylor.${data.aws_region.current.name}"
  subnet_id                   = "${data.aws_subnet.main-a.id}"
  user_data                   = "${file("ec2.awscda.ebs.userdata.sh")}"

  lifecycle {
    ignore_changes = [
      "tags.%",
      "tags.Created",
      "volume_tags.%",
      "volume_tags.Created",
      "volume_tags.Name",
      "volume_tags.ParentInstance",
    ]
  }

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james.lucktaylor.ec2.awscda",
      "StopDaily", "Yes",
    )
  )}"

  volume_tags = "${merge(
    local.default-tags,
    map(
      "Name", "james.lucktaylor.ec2.awscda.gp2",
    )
  )}"
}

resource "aws_ebs_volume" "sc1" {
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  count             = "${aws_instance.awscda.count}"
  size              = 500
  type              = "sc1"

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
      "Name", "james.lucktaylor.ec2.awscda.sc1"
    )
  )}"
}

resource "aws_volume_attachment" "sc1" {
  device_name = "/dev/sdb"
  instance_id = "${aws_instance.awscda.id}"
  volume_id   = "${aws_ebs_volume.sc1.id}"
}

resource "aws_ebs_volume" "st1" {
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  count             = "${aws_instance.awscda.count}"
  size              = 500
  type              = "st1"

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
      "Name", "james.lucktaylor.ec2.awscda.st1"
    )
  )}"
}

resource "aws_volume_attachment" "st1" {
  device_name = "/dev/sdc"
  instance_id = "${aws_instance.awscda.id}"
  volume_id   = "${aws_ebs_volume.st1.id}"
}

resource "aws_ebs_volume" "standard" {
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  count             = "${aws_instance.awscda.count}"
  size              = 8
  type              = "standard"

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
      "Name", "james.lucktaylor.ec2.awscda.standard"
    )
  )}"
}

resource "aws_volume_attachment" "standard" {
  device_name = "/dev/sdd"
  instance_id = "${aws_instance.awscda.id}"
  volume_id   = "${aws_ebs_volume.standard.id}"
}
