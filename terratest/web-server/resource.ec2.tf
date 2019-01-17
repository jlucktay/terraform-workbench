resource "aws_instance" "web_server" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.main.id}"

  vpc_security_group_ids = [
    "${aws_security_group.web_server.id}",
  ]

  # Run a "Hello, World" web server on port 8080
  user_data = "${file("ec2.web-server.user-data.sh")}"
}
