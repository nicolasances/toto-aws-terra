
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

variable "gcp_endpoint_suffix" {
  description = "GCP Endpoint Suffix for Toto services"
  type        = string
  sensitive   = true
  default     = ""
}

#########################################################
# 2. Code Build
#########################################################
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

#########################################################
# 4. DNS
#########################################################
variable "domain_name" {
  description = "Domain name for the service (e.g., example.com)"
  type        = string
}
#########################################################
# 5. GALE 
#########################################################
variable "gale_broker_url" {
  description = "URL of the Gale Broker"
  type        = string
}

#########################################################
# 6. Mongo Host 
#########################################################
variable "mongo_host" {
  description = "MongoDB host for Gale Broker"
  type        = string
}