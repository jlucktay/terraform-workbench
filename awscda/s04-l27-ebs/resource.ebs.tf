resource "aws_ebs_volume" "ebs" {
  availability_zone = "${element(aws_instance.awscda.*.availability_zone, count.index)}"
  count             = "${aws_instance.awscda.count * length(local.volumes)}"
  iops              = "${lookup(local.volumes[count.index % length(local.volumes)], "iops")}"
  size              = "${lookup(local.volumes[count.index % length(local.volumes)], "size")}"
  type              = "${lookup(local.volumes[count.index % length(local.volumes)], "aws_type")}"

  tags = {
    Name = "james.lucktaylor.ec2.awscda.${lookup(local.volumes[count.index % length(local.volumes)], "aws_type")}.${count.index}"
  }
}

resource "aws_volume_attachment" "attach" {
  count        = "${aws_instance.awscda.count * length(local.volumes)}"
  device_name  = "/dev/${lookup(local.volumes[count.index % length(local.volumes)], "linux_device")}"
  force_detach = true
  instance_id  = "${element(aws_instance.awscda.*.id, count.index)}"
  volume_id    = "${element(aws_ebs_volume.ebs.*.id, count.index)}"
}

### Might need something like this, to destroy volume attachments cleanly?
# provisioner "remote-exec" {
#   when = "destroy"
#
#   inline = [
#     "sudo umount /mnt/${lookup(local.volumes[count.index], "linux_device")}1",
#   ]
#
#   connection {
#     user        = "ec2-user"
#     host        = "${aws_instance.awscda.public_ip}"
#     private_key = "${file("~/.ssh/id_rsa")}"
#   }
# }
