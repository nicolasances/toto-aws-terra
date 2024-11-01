resource "aws_s3_bucket" "toto_models_bucket" {
    bucket = format("toto-%s-models.to7o.com", var.toto_environment)
    acl = "private"

    tags = {
        Name = "Toto Dev Models Bucket"
        Environment = var.toto_environment
    }
}