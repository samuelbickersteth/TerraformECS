resource "aws_ecs_task_definition" "fargate_task-definition" {
  network_mode              = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  family                    = "${var.app_name}-${var.env_name}-${var.app_component}"
  cpu                       = var.cpu #256
  memory                    = var.memory #512
  execution_role_arn        = var.execution_role_arn #aws_iam_role.ecs_task_execution_role.arn
  
  container_definitions = <<DEFINITION
 [{
    "name": "${var.app_name}-${var.env_name}-${var.app_component}",
    "image": "${var.ecr_repo_uri}",
    "essential": true,
    "environment": [{
            "name": "ApiAddress",
            "value": "http://internal-sam-bicky-prod-ecs-backend-lb-465664495.ca-central-1.elb.amazonaws.com/WeatherForecast"

    }],
    "portMappings": [{
        "containerPort": ${var.container_port},
        "hostPort": ${var.host_port}
    }],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-stream-prefix": "/ecs/${var.app_name}-${var.env_name}-${var.app_component}",
            "awslogs-group": "/ecs/${var.app_name}-${var.env_name}-${var.app_component}",
            "awslogs-region": "${var.region}"
        }
    }
}]
  DEFINITION
  
  tags = {
    "env"       = var.env_name
    "createdBy" = var.created_by
  }

}
resource "aws_security_group" "ecs_task" {
  name   = "${var.app_name}-${var.env_name}-${var.app_component}-ecs-sg"
  vpc_id = var.vpc_id
 
  ingress {
   protocol         = "tcp"
   from_port        = var.container_port
   to_port          = var.container_port
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
 
 
  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_lb_target_group" "lb_target_group_fargate" {
  name        = "${var.app_name}-${var.env_name}-${var.app_component}"
  port        = var.container_port
  protocol    = var.target_group_protocol
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path                = var.target_group_health_check
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
  stickiness {
        enabled  = true
        type = "lb_cookie"
      }
  
}
resource "aws_ecs_service" "service-fargate" {
  name            = "${var.app_name}-${var.env_name}-${var.app_component}"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.fargate_task-definition.arn
  desired_count   = 1
  scheduling_strategy                = "REPLICA"
  # ordered_placement_strategy {
  #   type  = "binpack"
  #   field = "memory"
  # }
  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group_fargate.arn
    container_name   = "${var.app_name}-${var.env_name}-${var.app_component}"
    container_port   = var.container_port
  }
  network_configuration {
   security_groups  = [aws_security_group.ecs_task.id]
   subnets          = var.private_subnets
   assign_public_ip = false
 }
  # Optional: Allow external changes without Terraform plan difference(for example ASG)
  # lifecycle {
  #   ignore_changes = [task_definition,desired_count]
  # }
  launch_type = "FARGATE"
  #depends_on  = [aws_lb_listener.https_frontend_listener]
}

resource "aws_cloudwatch_log_group" "log_group_fargate" {
  name = "/ecs/${var.app_name}-${var.env_name}-${var.app_component}"
  tags = {
    "env"       = var.env_name
    "createdBy" = var.created_by
  }
}



################################################################################