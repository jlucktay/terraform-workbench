output "ip" {
  value = "${aws_instance.web_server.public_ip}"
}

output "url" {
  value = "http://${aws_instance.web_server.public_dns}:8080"
}
