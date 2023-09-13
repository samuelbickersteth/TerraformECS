resource "aws_lb_listener" "web_http_listener" {
  load_balancer_arn = module.ecs.frontend_lb_arn
  port              = "80"
  protocol          = "HTTP"
  
  
  default_action {
    # type = "redirect"
    # redirect {
    #   port        = "443"
    #   protocol    = "HTTPS"
    #   status_code = "HTTP_301"
    # }
    type             = "forward"
    target_group_arn = module.ecs-frontend-service.ecs_target_group_arn
    
  }
}



resource "aws_lb_listener" "backend_http_listener" {
  load_balancer_arn = module.ecs.backend_lb_arn
  port              = "80"
  protocol          = "HTTP"
  
  
  default_action {
    # type = "redirect"
    # redirect {
    #   port        = "443"
    #   protocol    = "HTTPS"
    #   status_code = "HTTP_301"
    # }
    type             = "forward"
    target_group_arn = module.ecs-backend-service.ecs_target_group_arn
  }
       
}


