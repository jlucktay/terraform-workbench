output "awscda-efs-ip" {
  value = "${aws_instance.awscda-efs.*.public_ip}"
}

output "awscda-efs-lb-dns" {
  value = "${aws_lb.main.dns_name}"
}
