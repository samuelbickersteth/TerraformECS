resource "aws_lb" "frontend_lb" {
  name               = "${var.app_name}-${var.env_name}-ecs-frontend-lb"
  load_balancer_type = "application"
  internal           = false
  subnets            = module.vpc.public_subnets
  tags = {
    "env"       = var.env_name
    "createdBy" = var.created_by
  }
  security_groups = [aws_security_group.frontend_lb.id]
}

resource "aws_security_group" "frontend_lb" {
  name   = "${var.app_name}-${var.env_name}-allow-all-frontend-lb"
  vpc_id = data.aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # ingress {
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "env"       = var.env_name
    "createdBy" = var.created_by
  }
}




########################################################


resource "aws_lb" "backend_lb" {
  name               = "${var.app_name}-${var.env_name}-ecs-backend-lb"
  load_balancer_type = "application"
  internal           = true
  subnets            = module.vpc.public_subnets
  tags = {
    "env"       = var.env_name
    "createdBy" = var.created_by
  }
  security_groups = [aws_security_group.backend_lb.id]
}

resource "aws_security_group" "backend_lb" {
  name   = "${var.app_name}-${var.env_name}-allow-all-backend-lb"
  vpc_id = data.aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # ingress {
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "env"       = var.env_name
    "createdBy" = var.created_by
  }
}
