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
variable "aws_account_id" {
  description = "AWS Account Id"
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
########################################################
# 4. Terraform API Token
########################################################
variable "tf_api_token" {
  description = "Terraform API Token to be provided to Microservices repos as Secret"
  type = string
  sensitive = true
}
########################################################
# 5. Google Service Account Key (json file content) 
#    to allow for AWS to access GCP
########################################################
variable "gcp_service_account_key" {
  description = "Google Service Account Key to allow for AWS to access GCP"
  type = string
  sensitive = true
}