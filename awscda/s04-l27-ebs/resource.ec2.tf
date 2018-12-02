resource "aws_instance" "awscda" {
  ami                         = "${data.aws_ami.amazon-linux-latest.image_id}"
  associate_public_ip_address = true
  availability_zone           = "${element(data.aws_availability_zones.available.names, count.index)}"
  count                       = "${length(data.aws_availability_zones.available.names)}"
  instance_type               = "t2.micro"
  key_name                    = "james.lucktaylor.${data.aws_region.current.name}"
  subnet_id                   = "${data.aws_subnet.main-a.id}"
  user_data                   = "${file("ec2.awscda.ebs.userdata.sh")}"

  tags = {
    Name = "james.lucktaylor.ec2.awscda.${count.index}"
  }

  volume_tags = {
    Name = "james.lucktaylor.ec2.awscda.${count.index}"
  }

  lifecycle {
    ignore_changes = [
      "volume_tags.Name",
    ]
  }
}
