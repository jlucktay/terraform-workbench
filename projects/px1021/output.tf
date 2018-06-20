output "teleport-proxy-ip" {
  value = "${aws_instance.teleport-proxy.public_ip}"
}

output "teleport-target-ip" {
  value = "${aws_instance.teleport-target.public_ip}"
}
