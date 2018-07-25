resource "aws_ecs_task_definition" "task" {
  container_definitions = "${var.container_definitions}"
  family                = "${var.service_name}"
  task_role_arn         = "${var.task_role_arn}"

  placement_constraints {
    expression = "${element(var.placement_constraints, 0)}"
    type       = "memberOf"
  }

  placement_constraints {
    expression = "${element(var.placement_constraints, 1)}"
    type       = "memberOf"
  }

  placement_constraints {
    expression = "${element(var.placement_constraints, 2)}"
    type       = "memberOf"
  }
}
