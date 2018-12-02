output "awscda-ip" {
  value = "${aws_instance.awscda.*.public_ip}"
}
