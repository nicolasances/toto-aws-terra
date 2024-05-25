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