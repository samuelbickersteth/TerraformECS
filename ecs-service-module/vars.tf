variable "app_name" {

    default = ""
}
variable "env_name" {

    default = ""
}
variable "app_component" {

    default = ""
}
variable "region" {

    default = ""
}
variable "cidr" {

    default = ""
}
variable "container_port" {

    default = ""
}
variable "host_port" {

    default = ""
}
variable "public_subnets" {

    default = []
}
variable "private_subnets" {

    default = []
}

variable "created_by" {

    default = "Sam Bicky"
}
variable "env_file" {

    default = ""
}
variable "ecs_cluster_id" {

    default = ""
}
variable "aws_s3_bucket_arn" {

    default = ""
}
variable "cpu" {

    default = ""
}
variable "memory" {

    default = ""
}
variable "execution_role_arn" {

    default = ""
}
variable ecr_repo_uri {
    default = ""
}
variable vpc_id {
    default = ""
}

# variable lb_arn {
#     default = ""
# }
variable docker_command {
    default ="[\"nginx\", \"-g\", \"daemon off;\"]"

}
variable target_group_protocol {
    default ="HTTP"

}
variable target_group_health_check {
    default ="/"

}
