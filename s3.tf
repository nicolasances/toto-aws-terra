# S3 Bucket for CodeBuild
resource "aws_s3_bucket" "codebuild_artifacts" {
  bucket = "toto-${var.toto_env}-codebuild-artifacts-${var.aws_region}"
}
resource "aws_s3_bucket_acl" "codebuild_artifacts_acl" {
  bucket = aws_s3_bucket.codebuild_artifacts.id
  acl    = "private"
}
