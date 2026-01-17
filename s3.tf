# S3 Bucket for CodeBuild
resource "aws_s3_bucket" "codebuild_artifacts" {
  bucket = "toto-${var.toto_env}-codebuild-artifacts-${var.aws_region}"
}

# S3 Bucket for CodePipeline
resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket = "toto-codepipeline-artifacts-${var.toto_env}-${var.aws_region}"
  force_destroy = true # Allows deletion even if objects exist (for tear-down)
}
