resource "aws_instance" "awscda" {
  ami                         = "${data.aws_ami.amazon-linux-latest.image_id}"
  associate_public_ip_address = true
  availability_zone           = "${element(data.aws_availability_zones.available.names, count.index)}"
  instance_type               = "t2.micro"
  key_name                    = "james.lucktaylor.${data.aws_region.current.name}"
  subnet_id                   = "${data.aws_subnet.main-a.id}"
  user_data                   = "${file("ec2.awscda.ebs.userdata.sh")}"

  tags = {
    Name = "james.lucktaylor.ec2.awscda"
  }

  volume_tags = {
    Name = "james.lucktaylor.ec2.awscda"
  }
}

locals {
  drives = {
    sc1      = 500
    st1      = 500
    standard = 8
  }

  devices = [
    "sdb",
    "sdc",
    "sdd",
  ]
}

resource "aws_ebs_volume" "ebs" {
  availability_zone = "${aws_instance.awscda.availability_zone}"
  count             = "${length(local.drives)}"
  size              = "${element(values(local.drives), count.index)}"
  type              = "${element(keys(local.drives), count.index)}"

  tags = {
    Name = "james.lucktaylor.ec2.awscda.${element(keys(local.drives), count.index)}"
  }
}

resource "aws_volume_attachment" "attach" {
  count       = "${length(local.devices)}"
  device_name = "/dev/${element(local.devices, count.index)}"
  instance_id = "${aws_instance.awscda.id}"
  volume_id   = "${element(aws_ebs_volume.ebs.*.id, count.index)}"
}
