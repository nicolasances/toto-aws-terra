
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