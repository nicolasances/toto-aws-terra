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

variable "aws_route53_zone_id" {
  description = "AWS Route 53 Zone ID to be used"
  type = string
  sensitive = true
}

########################################################
# 2. Toto Environment & Core Variables
########################################################
variable "toto_environment" {
  description = "Toto Environment (dev, prod, etc..)"
  type = string
}
variable "jwt_signing_key" {
    description = "Toto Signing Key for JWT Tokens"
    type = string
    sensitive = true
}
variable "toto_domain_name" {
  description = "The Domain name used by Toto"
  type = string
}

########################################################
# 3. Github Core Variables
########################################################
variable "github_token" {
  description = "Github PAT for Terraform to use"
  type = string
  sensitive = true
}