output "teleport-proxy-ip" {
  value = "${aws_instance.teleport-proxy.public_ip}"
}
