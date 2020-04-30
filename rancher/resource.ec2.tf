resource "aws_instance" "main" {
  count = 1

  ami                         = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  availability_zone           = element(data.aws_availability_zones.available.names, count.index)
  disable_api_termination     = false
  instance_type               = "t2.large"
  key_name                    = "jlucktay.eu-west-2"
  subnet_id                   = element(data.aws_subnet.public.*.id, count.index)
  user_data                   = file(join("/", [path.module, "user-data.sh"]))

  vpc_security_group_ids = [
    data.aws_security_group.dmz.id
  ]

  tags = {
    Name = "jlucktay.ec2.rancher.${count.index}"
  }

  volume_tags = {
    Name = "jlucktay.ec2.rancher.${count.index}"
  }

  lifecycle {
    ignore_changes = [
      volume_tags.Name,
    ]
  }
}
