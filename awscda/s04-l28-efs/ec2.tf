resource "aws_instance" "awscda-efs" {
  ami                         = "${data.aws_ami.amazon-linux-latest.image_id}"
  associate_public_ip_address = true
  count                       = "${length(data.aws_availability_zones.available.names)}"
  instance_type               = "t2.micro"
  key_name                    = "james.lucktaylor.${data.aws_region.current.name}"
  subnet_id                   = "${element(data.aws_subnet_ids.main.ids, count.index)}"
  user_data                   = "${replace(file("ec2.awscda.efs.userdata.sh"), "!!EFS_ID!!", "${aws_efs_file_system.main.id}")}"

  lifecycle {
    ignore_changes = [
      "tags.%",
      "tags.Created",
    ]
  }

  /*
  provisioner "remote-exec" {
    inline = ["rm /var/www/html/index.html"]
    when   = "destroy"

    connection {
      agent       = false
      port        = "22"
      private_key = "${file("/Users/jameslucktaylor/Google Drive File Stream/My Drive/Auth/Keys/Asymmetrical/Cloudreach/AWS/james.lucktaylor.eu-west-1.pem")}"
      timeout     = "10s"
      type        = "ssh"
      user        = "ec2-user"
    }
  }
  */

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james.lucktaylor.ec2.awscda.efs.${count.index}",
      "StopDaily", "Yes",
    )
  )}"
  vpc_security_group_ids = [
    "${data.aws_security_group.default.id}",
    "${data.aws_security_group.dmz.id}",
  ]
}
