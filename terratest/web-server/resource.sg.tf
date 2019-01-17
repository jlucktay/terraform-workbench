resource "aws_security_group" "web_server" {
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["185.100.71.242/32"]
  }
}
