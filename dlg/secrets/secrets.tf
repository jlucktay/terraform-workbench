resource "aws_secretsmanager_secret" "fa-sftp-ec2" {
  description             = "Public key for Fraud Analytics SFTP EC2"
  recovery_window_in_days = "30"
  name                    = "fa-sftp-ec2"
}

resource "aws_secretsmanager_secret_version" "fa-sftp-ec2" {
  secret_id     = "${aws_secretsmanager_secret.fa-sftp-ec2.id}"
  secret_string = "${file("fa-sftp-ec2.pub")}"
}
