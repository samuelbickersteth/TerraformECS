
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.app_name}-${var.env_name}"
  tags = {
    "env"       = var.env_name
    "createdBy" = var.created_by
  }
}



################################################################################