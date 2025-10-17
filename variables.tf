
data "aws_caller_identity" "current" {}

output "aws_account_id" {
  description = "The AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

########################################################
# 1. Toto Environment & Core Variables
########################################################
variable "toto_env" {
  description = "Toto Environment (dev, prod, etc..)"
  type = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-north-1"
}

#########################################################
# 2. Code Build
#########################################################
variable "codebuild_role_arn" {
  description = "ARN of the IAM Role for CodeBuild"
  type        = string
}
variable "code_connection_arn" {
  description = "ARN of the CodeStar Connection for GitHub"
  type        = string
}
variable "code_connection_hash" {
  description = "Hash of the CodeStar Connection for GitHub (it's the last part of the ARN, after the last /)"
  type        = string
}

#########################################################
# 3. Certificates
#########################################################
variable "alb_certificate_arn" {
  description = "ARN of the ACM Certificate for the Application Load Balancer"
  type        = string
}