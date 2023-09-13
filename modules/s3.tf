# resource "aws_s3_bucket" "codepipeline_frontend_bucket" {
#     bucket_prefix = "${var.app_name}-${var.env_name}-codepipeline"
#     acl    = "private"
#     force_destroy = true

# }
# resource "aws_s3_bucket" "codepipeline_backend_bucket" {
#     bucket_prefix = "${var.app_name}-${var.env_name}-codepipeline"
#     acl    = "private"
#     force_destroy = true
    
# }
# resource "aws_s3_bucket" "task_definition_env_file" {
#     bucket_prefix = "${var.app_name}-${var.env_name}-ecs-env-file"
#     acl    = "private"
#     force_destroy = true
    
# }