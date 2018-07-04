#-----------------------------------------------------------------------
# This module looks up the latest Amazon Linux 2 AMI and returns the ID
#-----------------------------------------------------------------------

output "latest_ami" {
  value = "${data.aws_ami.debian_latest.image_id}"
}

output "latest_platform" {
  value = "${data.aws_ami.debian_latest.platform}"
}
