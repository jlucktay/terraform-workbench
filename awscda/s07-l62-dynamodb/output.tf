output "awscda-ec2-dyndb-ip" {
  value = "${aws_instance.awscda-dyndb.public_ip}"
}
