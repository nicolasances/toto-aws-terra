terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3"
  backend "s3" {
    bucket      = "nimat-${var.toto_env}-terraform-bucket"
    key         = "myproject/prod/terraform.tfstate"
    region      = var.aws_region                   
    use_lockfile = true                           # S3 native locking (recommended)
    encrypt     = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}
