output cluster_id {
    value = aws_ecs_cluster.ecs_cluster.id
}

output ecr_repo_uri_api{
    value = aws_ecr_repository.api_app_repo.repository_url
}

output ecr_repo_uri_frontend{
    value = aws_ecr_repository.web_app_repo.repository_url
}
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "frontend_lb_arn" {
  value = aws_lb.frontend_lb.arn
}

output "backend_lb_arn" {
  value = aws_lb.backend_lb.arn
}

output ecs_task_definition_execution_role_arn {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output vpc_private_subnets {
  value = module.vpc.private_subnets
}

output vpc_public_subnets {
  value = module.vpc.public_subnets
}
