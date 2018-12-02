locals {
  volumes = [
    {
      aws_type     = "gp2"
      iops         = 0
      linux_device = "sdb"
      size         = "1"
    },
    {
      aws_type     = "io1"
      iops         = 100
      linux_device = "sdc"
      size         = "4"
    },
    {
      aws_type     = "st1"
      iops         = 0
      linux_device = "sdd"
      size         = "500"
    },
    {
      aws_type     = "sc1"
      iops         = 0
      linux_device = "sde"
      size         = "500"
    },
    {
      aws_type     = "standard"
      iops         = 0
      linux_device = "sdf"
      size         = "1"
    },
  ]
}
