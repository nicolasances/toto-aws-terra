# 1. IAM Role that CodeBuild service can assume
resource "aws_iam_role" "codebuild_role" {
  name = "TotoTFCodeBuildRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

# 2. IAM Policy document for permissions
data "aws_iam_policy_document" "codebuild_policy_doc" {
  statement {
    sid    = "CloudWatchLogsAccess"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"] # Standard logs access
  }

  statement {
    sid    = "S3ArtifactsAccess"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
    ]
    resources = [
      aws_s3_bucket.codebuild_artifacts.arn,
      "${aws_s3_bucket.codebuild_artifacts.arn}/*",
    ]
  }

  statement {
    sid    = "CodeStarConnectionAccess"
    effect = "Allow"
    actions = [
        "codestar-connections:GetConnectionToken",
        "codestar-connections:GetConnection",
        "codeconnections:GetConnectionToken",
        "codeconnections:GetConnection",
        "codeconnections:UseConnection",
    ]
    # Grant permission to use the specific connection for source checkout
    # IMPORTANT: it seems like it was important to have both the versions of the code connection ARN below. Won't work with only codeconnections
    resources = [
        "arn:aws:codestar-connections:${var.aws_region}:${data.aws_caller_identity.current.account_id}:connection/${var.code_connection_hash}",
        "arn:aws:codeconnections:${var.aws_region}:${data.aws_caller_identity.current.account_id}:connection/${var.code_connection_hash}",
    ] 
  }

  # ECR Permissions (for both pulling base images and pushing results)
  statement {
    sid    = "ECRContainerRegistryAccess"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",       # CRITICAL: Needed for pulling image manifests (The action in your error)
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"             # CRITICAL: Needed for pushing the final image
    ]
    resources = ["*"] # Required for GetAuthorizationToken
  }
}

# 3. Attach the policy to the role
resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "TotoTFCodeBuildPolicy"
  role   = aws_iam_role.codebuild_role.id
  policy = data.aws_iam_policy_document.codebuild_policy_doc.json
}
