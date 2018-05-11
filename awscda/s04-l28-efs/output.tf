output "awscda-efs-ip" {
  value = "${aws_instance.awscda-efs.*.public_ip}"
}
