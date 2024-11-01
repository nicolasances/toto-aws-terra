resource "aws_s3_bucket" "toto_models_bucket" {
    bucket = "toto-dev-models.to7o.com"
    acl = "private"

    tags = {
        Name = "Toto Dev Models Bucket"
        Environment = "dev"
    }
}