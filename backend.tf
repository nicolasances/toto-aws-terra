terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3"
  backend "s3" { } # Check backend-dev.tfbackend for details or backend-prod.tfbackend (based on environment)
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"
}
