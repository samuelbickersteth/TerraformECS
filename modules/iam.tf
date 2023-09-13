data "aws_caller_identity" "current" {}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.app_name}-${var.env_name}-task-execution-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  
}

resource "aws_iam_role_policy" "aws_ecs_task_execution_policy" {
  role = aws_iam_role.ecs_task_execution_role.id
    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                 "s3:GetObject"
            ],
            "Resource": "*"
        },
        {
            "Sid": "SSMGetParameters",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameter"
            ],
            "Resource": "*"
        },
        {
            "Sid": "KMSDecryptParametersWithKey",
            "Effect": "Allow",
            "Action": [
                "kms:GetPublicKey",
                "kms:Decrypt",
                "kms:GenerateDataKey",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

# resource "aws_iam_role" "codebuild_role" {
#     name = "${var.env_name}-${var.app_name}-codebuild-role-${var.region}"
#     assume_role_policy = <<-EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#         "Effect": "Allow",
#         "Principal": {
#             "Service": "codebuild.amazonaws.com"
#         },
#         "Action": "sts:AssumeRole"
#         }
#     ]
# }
# EOF
    
# }
# resource "aws_iam_role_policy" "codebuild_policy" {
#     role = aws_iam_role.codebuild_role.id
#     policy = <<POLICY
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Resource": [
#                 "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/*",
#                 "arn:aws:codebuild:${var.region}:${data.aws_caller_identity.current.account_id}:build/*:*",
#                 "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:*:*"
#             ],
#             "Action": [
#                 "logs:CreateLogGroup",
#                 "logs:CreateLogStream",
#                 "logs:PutLogEvents"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Resource": [
#                 "${aws_s3_bucket.codepipeline_frontend_bucket.arn}",
#                 "${aws_s3_bucket.codepipeline_frontend_bucket.arn}/*",
#                 "${aws_s3_bucket.codepipeline_backend_bucket.arn}",
#                 "${aws_s3_bucket.codepipeline_backend_bucket.arn}/*",
#                 "${aws_s3_bucket.task_definition_env_file.arn}",
#                 "${aws_s3_bucket.task_definition_env_file.arn}/*"
#             ],
#             "Action": [
#                 "s3:PutObject",
#                 "s3:GetObject",
#                 "s3:GetObjectVersion",
#                 "s3:GetBucketAcl",
#                 "s3:GetBucketLocation"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "codebuild:CreateReportGroup",
#                 "codebuild:CreateReport",
#                 "codebuild:UpdateReport",
#                 "codebuild:BatchPutTestCases",
#                 "codebuild:BatchPutCodeCoverages"
#             ],
#             "Resource": [
#                 "arn:aws:codebuild:${var.region}:${data.aws_caller_identity.current.account_id}:report-group/*"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:CreateNetworkInterface",
#                 "ec2:DescribeDhcpOptions",
#                 "ec2:DescribeNetworkInterfaces",
#                 "ec2:DeleteNetworkInterface",
#                 "ec2:DescribeSubnets",
#                 "ec2:DescribeSecurityGroups",
#                 "ec2:DescribeVpcs"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:CreateNetworkInterfacePermission"
#             ],
#             "Resource": "arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:network-interface/*",
#             "Condition": {
#                 "StringEquals": {
#                     "ec2:Subnet": [
#                         "arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:subnet/${module.vpc.private_subnets[0]}",
#                         "arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:subnet/${module.vpc.private_subnets[1]}"
#                     ],
#                     "ec2:AuthorizedService": "codebuild.amazonaws.com"
#                 }
#             }
#         },
#         {
#             "Effect":"Allow",
#             "Action":[
#                 "ssm:GetParameters",
#                 "ecr:*"
#             ],
#             "Resource": "*"
#         }
#     ]
# }
# POLICY
# }
# #######################
# ##### CodePipeline Role
# #######################
# resource "aws_iam_role" "codepipeline_role" {
#     name = "${var.env_name}-${var.app_name}-codepipeline-role-${var.region}"
#     assume_role_policy = <<-EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#         "Effect": "Allow",
#         "Principal": {
#             "Service": "codepipeline.amazonaws.com"
#         },
#         "Action": "sts:AssumeRole"
#         }
#     ]
# }
# EOF
   
# }
# resource "aws_iam_role_policy" "codepipeline_policy" {
#     name = "${var.env_name}-codepipeline-policy"
#     role = aws_iam_role.codepipeline_role.id
#     policy = <<EOF
# {
#     "Statement": [
#         {
#             "Action": [
#                 "iam:PassRole"
#             ],
#             "Resource": "*",
#             "Effect": "Allow",
#             "Condition": {
#                 "StringEqualsIfExists": {
#                     "iam:PassedToService": [
#                         "ec2.amazonaws.com"
#                     ]
#                 }
#             }
#         },
#         {
#             "Action": [
#                 "codestar-connections:UseConnection"
#             ],
#             "Resource": "*",
#             "Effect": "Allow"
#         },
#         {
#             "Action": [
#                 "codecommit:CancelUploadArchive",
#                 "codecommit:GetBranch",
#                 "codecommit:GetCommit",
#                 "codecommit:GetRepository",
#                 "codecommit:GetUploadArchiveStatus",
#                 "codecommit:UploadArchive"
#             ],
#             "Resource": "*",
#             "Effect": "Allow"
#         },
#         {
#             "Action": [
#                 "codedeploy:CreateDeployment",
#                 "codedeploy:GetApplication",
#                 "codedeploy:GetApplicationRevision",
#                 "codedeploy:GetDeployment",
#                 "codedeploy:GetDeploymentConfig",
#                 "codedeploy:RegisterApplicationRevision"
#             ],
#             "Resource": "*",
#             "Effect": "Allow"
#         },
#         {
#             "Action": [
#                 "ec2:*",
#                 "elasticloadbalancing:*",
#                 "autoscaling:*",
#                 "cloudwatch:*",
#                 "s3:*",
#                 "sns:*",
#                 "rds:*"
#             ],
#             "Resource": "*",
#             "Effect": "Allow"
#         },
#         {
#             "Action": [
#                 "opsworks:CreateDeployment",
#                 "opsworks:DescribeApps",
#                 "opsworks:DescribeCommands",
#                 "opsworks:DescribeDeployments",
#                 "opsworks:DescribeInstances",
#                 "opsworks:DescribeStacks",
#                 "opsworks:UpdateApp",
#                 "opsworks:UpdateStack"
#             ],
#             "Resource": "*",
#             "Effect": "Allow"
#         },
#         {
#             "Action": [
#                 "codebuild:BatchGetBuilds",
#                 "codebuild:StartBuild",
#                 "codebuild:BatchGetBuildBatches",
#                 "codebuild:StartBuildBatch"
#             ],
#             "Resource": "*",
#             "Effect": "Allow"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "devicefarm:ListProjects",
#                 "devicefarm:ListDevicePools",
#                 "devicefarm:GetRun",
#                 "devicefarm:GetUpload",
#                 "devicefarm:CreateUpload",
#                 "devicefarm:ScheduleRun"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "servicecatalog:ListProvisioningArtifacts",
#                 "servicecatalog:CreateProvisioningArtifact",
#                 "servicecatalog:DescribeProvisioningArtifact",
#                 "servicecatalog:DeleteProvisioningArtifact",
#                 "servicecatalog:UpdateProduct"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "states:DescribeExecution",
#                 "states:DescribeStateMachine",
#                 "states:StartExecution"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "appconfig:StartDeployment",
#                 "appconfig:StopDeployment",
#                 "appconfig:GetDeployment"
#             ],
#             "Resource": "*"
#         },
#                 {
#             "Action": [
#                 "ecs:*",
#                 "elasticloadbalancing:DescribeTargetGroups",
#                 "elasticloadbalancing:DescribeListeners",
#                 "elasticloadbalancing:ModifyListener",
#                 "elasticloadbalancing:DescribeRules",
#                 "elasticloadbalancing:ModifyRule",
#                 "lambda:InvokeFunction",
#                 "cloudwatch:DescribeAlarms",
#                 "sns:Publish",
#                 "s3:GetObject",
#                 "s3:GetObjectVersion"
#             ],
#             "Resource": "*",
#             "Effect": "Allow"
#         },
#         {
#             "Action": [
#                 "iam:PassRole"
#             ],
#             "Effect": "Allow",
#             "Resource": "*",
#             "Condition": {
#                 "StringLike": {
#                     "iam:PassedToService": [
#                         "ecs-tasks.amazonaws.com"
#                     ]
#                 }
#             }
#         }
#     ],
#     "Version": "2012-10-17"
# }
# EOF
# } 
