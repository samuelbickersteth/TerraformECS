

############
# PROVIDERS
############

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
  version = "4.67.0"
}


terraform {
  # backend "s3" {
  #   bucket = "sam-dev-ca-central-1-tf-state"
  #   key    = "terraform.tfstate"
  #   region = "ca-central-1"
  #   dynamodb_table = "sam-dev-state-lock-table"
  #   encrypt        = true
  # }
   backend "local" {
    path = "terraform.tfstate"
  }
}

module ecs {

    source  = "../modules"

    app_name=var.app_name
    env_name=var.env_name
    region=var.region
    cidr=var.cidr
    azs=["${var.region}a","${var.region}b","${var.region}c"]
    public_subnets=var.public_subnets
    private_subnets=var.private_subnets

}

module ecs-frontend-service {

    source  = "../ecs-service-module"
    ecs_cluster_id = module.ecs.cluster_id
    app_component = "frontend"
    app_name=var.app_name
    env_name=var.env_name
    region=var.region
    public_subnets=module.ecs.vpc_public_subnets
    private_subnets=module.ecs.vpc_private_subnets
    host_port="5000"
    container_port="5000"
    cpu = 256
    memory = 512
    execution_role_arn = module.ecs.ecs_task_definition_execution_role_arn
    ecr_repo_uri = module.ecs.ecr_repo_uri_frontend
    vpc_id = module.ecs.vpc_id
}

module ecs-backend-service {

    source  = "../ecs-service-module"
    ecs_cluster_id = module.ecs.cluster_id
    app_name=var.app_name
    env_name=var.env_name
    app_component = "backend"
    region=var.region
    public_subnets=module.ecs.vpc_public_subnets
    private_subnets=module.ecs.vpc_private_subnets
    host_port= "5000"
    container_port =  "5000"
    cpu = 256
    memory = 512
    execution_role_arn = module.ecs.ecs_task_definition_execution_role_arn
    ecr_repo_uri = module.ecs.ecr_repo_uri_api
    vpc_id = module.ecs.vpc_id
}