resource "aws_ecr_repository" "web_app_repo" {
  name                 = "${var.app_name}-${var.env_name}-frontend"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    "env"       = var.env_name
    "createdBy" = var.created_by
  } 
 
}

resource "aws_ecr_lifecycle_policy" "web_repo_policy" {
  repository = aws_ecr_repository.web_app_repo.name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 5 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 5
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

resource "aws_ecr_repository" "api_app_repo" {
  name                 = "${var.app_name}-${var.env_name}-backend"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    "env"       = var.env_name
    "createdBy" = var.created_by
  }
   
  
}

resource "aws_ecr_lifecycle_policy" "api_repo_policy" {
  repository = aws_ecr_repository.api_app_repo.name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 5 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 5
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

