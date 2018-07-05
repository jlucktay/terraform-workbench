locals {
  default_tags = {
    KillDate        = "01/01/2019"
    Name            = "james.lucktaylor.teleport"
    Owner           = "james.lucktaylor"
    Purpose         = "Client PoC/demo"
    TeleportCluster = "${var.cluster_name}"
  }

  default_tags_asg = [
    {
      key                 = "KillDate"
      propagate_at_launch = true
      value               = "01/01/2019"
    },
    {
      key                 = "Name"
      propagate_at_launch = true
      value               = "james.lucktaylor.teleport"
    },
    {
      key                 = "Owner"
      propagate_at_launch = true
      value               = "james.lucktaylor"
    },
    {
      key                 = "Purpose"
      propagate_at_launch = true
      value               = "Client PoC/demo"
    },
    {
      key                 = "ScaleDownDaily"
      propagate_at_launch = true
      value               = "Yes"
    },
    {
      key                 = "StopDaily"
      propagate_at_launch = true
      value               = "No"
    },
    {
      key                 = "TeleportCluster"
      propagate_at_launch = true
      value               = "${var.cluster_name}"
    },
  ]
}
