
output "ip" {
  value = join("", aws_instance.main.*.public_ip)
}
