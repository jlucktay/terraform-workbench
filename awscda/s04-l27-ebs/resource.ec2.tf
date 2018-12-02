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
  volumes = [
    {
      aws_type     = "sc1"
      linux_device = "sdb"
      size         = "500"
    },
    {
      aws_type     = "st1"
      linux_device = "sdc"
      size         = "500"
    },
    {
      aws_type     = "standard"
      linux_device = "sdd"
      size         = "8"
    },
  ]
}

resource "aws_ebs_volume" "ebs" {
  availability_zone = "${aws_instance.awscda.availability_zone}"
  count             = "${length(local.volumes)}"
  size              = "${lookup(local.volumes[count.index], "size")}"
  type              = "${lookup(local.volumes[count.index], "aws_type")}"

  tags = {
    Name = "james.lucktaylor.ec2.awscda.${lookup(local.volumes[count.index], "aws_type")}"
  }
}

resource "aws_volume_attachment" "attach" {
  count       = "${length(local.volumes)}"
  device_name = "/dev/${lookup(local.volumes[count.index], "linux_device")}"
  instance_id = "${aws_instance.awscda.id}"
  volume_id   = "${element(aws_ebs_volume.ebs.*.id, count.index)}"
}
