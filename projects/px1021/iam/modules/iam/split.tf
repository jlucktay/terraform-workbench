# Following a pattern from here:
# https://serialseb.com/blog/2016/05/11/terraform-working-around-no-count-on-module/

resource "null_resource" "roles" {
  count = "${length(split(var.role-delimiter, var.role-names))}"

  triggers {
    name = "${element(split(var.role-delimiter, var.role-names), count.index)}"
  }
}
