output "ecs_target_group_arn" {
  value = aws_lb_target_group.lb_target_group_fargate.arn
}