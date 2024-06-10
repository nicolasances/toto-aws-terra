########################################################
# 1. AWS Core Variables
########################################################
variable "aws_access_key" {
  description = "Access Key"
  type = string
  sensitive = true
}

variable "aws_secret_access_key" {
  description = "Secret Access Key"
  type = string
  sensitive = true
}

variable "aws_account_id" {
  description = "Account ID"
  type = string
  sensitive = true
}

variable "toto_environment" {
  description = "Toto Environment (dev, prod, etc..)"
  type = string
}

variable "toto_vpc_id" {
  description = "ID of the VPC that host Toto Services"
  type = string
}
variable "ecs_subnet_1" {
  description = "ARN of one of the two subnets to be used"
  type = string
}
variable "ecs_subnet_2" {
  description = "ARN of the other of the two subnets to be used"
  type = string
}
variable "ecs_security_group" {
  description = "value"
  type = string
}
variable "alb_listener_arn" {
  description = "Listener ARN of the ALB"
  type = string
}
variable "alb_zone_id" {
  description = "Zone ID of the ALB needed for the Route53 routing alias configuration"
  type = string
}
variable "alb_dns_name" {
  description = "DNS Name of the ALB needed for the Route53 routing alias configuration"
  type = string
}
variable "route53_zone_id" {
  description = "Route53 Zone ID used for creating DNS A Records"
  type = string
}
variable "ecs_execution_role_arn" {
  description = "ECS Task Execution Role ARN for the environment"
  type = string
  sensitive = true
}
variable "ecs_task_role_arn" {
  description = "ECS Task role ARN for the environment"
  type = string
  sensitive = true
}
variable "ecs_cluster_arn" {
  description = "ECS Cluster ARN for the environment"
  type = string
  sensitive = true
}
########################################################
# 4. Terraform API Token
########################################################
variable "tf_api_token" {
  description = "Terraform API Token to be provided to Microservices repos as Secret"
  type = string
  sensitive = true
}