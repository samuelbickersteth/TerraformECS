variable "aws_access_key" {
  default=""
}

variable "aws_secret_key" {
  default=""
}
variable "app_name" {

    default = ""
}
variable "env_name" {

    default = ""
}
variable "region" {

    default = ""
}
variable "cidr" {

    default = ""
}
variable "azs" {

    default = ""
}
variable "public_subnets" {

    default = []
}
variable "private_subnets" {

    default = []
}
variable "enable_nat_gateway" {

    default = true
}
variable "single_nat_gateway" {

    default = true
}
variable "one_nat_gateway_per_az" {

    default = false
}
variable "created_by" {

    default = "Sayraab"
}
variable "db_password" {

    default = ""
}

variable "connection_arn" {

    default = ""
}
variable "frontend_full_repository_id" {

    default = ""
}
variable "backend_full_repository_id" {

    default = ""
}
variable "frontend_branch" {

    default = "cicd-testing"
}
variable "backend_branch" {

    default = "cicd-testing"
}
