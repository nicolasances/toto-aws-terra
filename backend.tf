terraform {
  required_version = ">= 1.3"
  backend "s3" {
    bucket      = "nimat-terraform-bucket"    
    key         = "myproject/prod/terraform.tfstate"
    region      = "eu-north-1"                    
    use_lockfile = true                           # S3 native locking (recommended)
    encrypt     = true
  }
}
