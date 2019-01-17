resource "aws_instance" "web_server" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.web_server.id}"]

  # Run a "Hello, World" web server on port 8080
  user_data = <<EOF
#!/bin/bash
echo "Hello, World" > index.html
nohup busybox httpd -f -p 8080 &
EOF
}
