# Following a pattern from here:
# https://serialseb.com/blog/2016/05/11/terraform-working-around-no-count-on-module/
# ...until this issue is resolved:
# https://github.com/hashicorp/terraform/issues/953

resource "null_resource" "roles" {
  count = "${length(split(var.role-delimiter, var.role-names))}"

  triggers {
    name = "${element(split(var.role-delimiter, var.role-names), count.index)}"
  }
}
