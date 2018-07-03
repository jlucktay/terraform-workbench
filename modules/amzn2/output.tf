#-----------------------------------------------------------------------
# This module looks up the latest Amazon Linux 2 AMI and returns the ID
#-----------------------------------------------------------------------

output "latest_ami" {
  value = "${data.aws_ami.amazon_linux_2_latest.image_id}"
}
