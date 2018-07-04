#-----------------------------------------------------------------------
# This module looks up the latest Debian AMI and returns the ID
#-----------------------------------------------------------------------

output "latest_ami" {
  value = "${data.aws_ami.debian_latest.image_id}"
}
