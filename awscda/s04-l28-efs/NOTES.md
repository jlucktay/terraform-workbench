# EFS

- ~~EFS mount targets~~
  - ~~across all AZs~~
- ~~EC2s~~
  - ~~across all AZs~~
  - ~~same SG(s) as EFS~~
  - ~~user data script~~
    - ~~`yum install httpd -y`~~
    - ~~`service httpd start`~~
    - ~~get EFS `mount` command, and mount on `/var/www/html`~~
    - add line to `/etc/fstab` for persistence
- Elastic load balancer
  - port 80
  - health check interval: 10 seconds
  - healthy threshold: 3
  - add all EC2s
  - use [ALB](https://www.terraform.io/docs/providers/aws/r/lb.html) instead
