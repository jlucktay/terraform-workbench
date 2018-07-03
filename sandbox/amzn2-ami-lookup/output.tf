output "amzn2-ami-architecture" {
  value = "${data.aws_ami.amazon-linux-2-latest.architecture}"
}

output "amzn2-ami-block_device_mappings" {
  value = "${data.aws_ami.amazon-linux-2-latest.block_device_mappings}"
}

output "amzn2-ami-creation_date" {
  value = "${data.aws_ami.amazon-linux-2-latest.creation_date}"
}

output "amzn2-ami-description" {
  value = "${data.aws_ami.amazon-linux-2-latest.description}"
}

output "amzn2-ami-hypervisor" {
  value = "${data.aws_ami.amazon-linux-2-latest.hypervisor}"
}

output "amzn2-ami-image_id" {
  value = "${data.aws_ami.amazon-linux-2-latest.image_id}"
}

output "amzn2-ami-image_location" {
  value = "${data.aws_ami.amazon-linux-2-latest.image_location}"
}

output "amzn2-ami-image_owner_alias" {
  value = "${data.aws_ami.amazon-linux-2-latest.image_owner_alias}"
}

output "amzn2-ami-image_type" {
  value = "${data.aws_ami.amazon-linux-2-latest.image_type}"
}

### Only applicable for machine images.
# output "amzn2-ami-kernel_id" {
#   value = "${data.aws_ami.amazon-linux-2-latest.kernel_id}"
# }

output "amzn2-ami-name" {
  value = "${data.aws_ami.amazon-linux-2-latest.name}"
}

output "amzn2-ami-owner_id" {
  value = "${data.aws_ami.amazon-linux-2-latest.owner_id}"
}

### The value is Windows for Windows AMIs; otherwise blank.
# output "amzn2-ami-platform" {
#   value = "${data.aws_ami.amazon-linux-2-latest.platform}"
# }

output "amzn2-ami-product_codes" {
  value = "${data.aws_ami.amazon-linux-2-latest.product_codes}"
}

output "amzn2-ami-public" {
  value = "${data.aws_ami.amazon-linux-2-latest.public}"
}

### Only applicable for machine images.
# output "amzn2-ami-ramdisk_id" {
#   value = "${data.aws_ami.amazon-linux-2-latest.ramdisk_id}"
# }

output "amzn2-ami-root_device_name" {
  value = "${data.aws_ami.amazon-linux-2-latest.root_device_name}"
}

output "amzn2-ami-root_device_type" {
  value = "${data.aws_ami.amazon-linux-2-latest.root_device_type}"
}

output "amzn2-ami-root_snapshot_id" {
  value = "${data.aws_ami.amazon-linux-2-latest.root_snapshot_id}"
}

output "amzn2-ami-sriov_net_support" {
  value = "${data.aws_ami.amazon-linux-2-latest.sriov_net_support}"
}

output "amzn2-ami-state" {
  value = "${data.aws_ami.amazon-linux-2-latest.state}"
}

output "amzn2-ami-tags" {
  value = "${data.aws_ami.amazon-linux-2-latest.tags}"
}

output "amzn2-ami-virtualization_type" {
  value = "${data.aws_ami.amazon-linux-2-latest.virtualization_type}"
}
