module "vpc" {
  source            = "terraform-aws-modules/vpc/aws"
  version           = "3.7.0"
  name              = "${var.app_name}-${var.env_name}"
  cidr              = var.cidr
  azs               = var.azs
  public_subnets    = var.public_subnets
  private_subnets   = var.private_subnets
  
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  tags = {
    "env"       = var.env_name
    "createdBy" = var.created_by
  }

}

data "aws_vpc" "main" {
  id = module.vpc.vpc_id
}