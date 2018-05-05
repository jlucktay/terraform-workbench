resource "aws_instance" "awscda" {
  ami           = "${data.aws_ami.amazon-linux-latest.image_id}"
  instance_type = "t2.micro"

  lifecycle {
    ignore_changes = [
      "tags.%",
      "tags.Created",
      "tags.StopDaily",
    ]
  }

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james.lucktaylor.ec2.awscda"
    )
  )}"
}

resource "aws_ebs_volume" "gp2" {
  availability_zone = "${element(data.aws_availability_zones.available.names, 2)}"
  size              = 8

  lifecycle {
    ignore_changes = [
      "tags.%",
      "tags.ParentInstance",
    ]
  }

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james.lucktaylor.ec2.awscda.gp2"
    )
  )}"
}

resource "aws_volume_attachment" "gp2" {
  device_name = "/dev/xvda"
  instance_id = "${aws_instance.awscda.id}"
  volume_id   = "${aws_ebs_volume.gp2.id}"
}

resource "aws_ebs_volume" "sc1" {
  availability_zone = "${element(data.aws_availability_zones.available.names, 2)}"
  size              = 500

  lifecycle {
    ignore_changes = [
      "tags.%",
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
  availability_zone = "${element(data.aws_availability_zones.available.names, 2)}"
  size              = 500

  lifecycle {
    ignore_changes = [
      "tags.%",
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
  availability_zone = "${element(data.aws_availability_zones.available.names, 2)}"
  size              = 8

  lifecycle {
    ignore_changes = [
      "tags.%",
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
