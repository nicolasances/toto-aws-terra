terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3"
  backend "s3" {
    bucket      = "nimat-terraform-bucket"    
    key         = "myproject/prod/terraform.tfstate"
    region      = "eu-north-1"                    
    use_lockfile = true                           # S3 native locking (recommended)
    encrypt     = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"
}
