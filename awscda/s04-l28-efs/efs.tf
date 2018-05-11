resource "aws_efs_file_system" "main" {
  creation_token = "james.lucktaylor.efs"

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james.lucktaylor.efs",
    )
  )}"
}

resource "aws_efs_mount_target" "main" {
  count           = "${length(data.aws_availability_zones.available.names)}"
  file_system_id  = "${aws_efs_file_system.main.id}"
  security_groups = ["${data.aws_security_group.default.id}"]
  subnet_id       = "${element(data.aws_subnet_ids.main.ids, count.index)}"
}
