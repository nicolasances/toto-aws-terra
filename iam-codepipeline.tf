resource "aws_iam_role" "codepipeline_role" {
  name = "TotoPipelineRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

data "aws_iam_policy_document" "codepipeline_policy_doc" {
  statement {
    sid    = "AllowS3BucketAccess"
    effect = "Allow"
    actions = [
        "s3:GetBucketVersioning",
        "s3:GetBucketAcl",
        "s3:GetBucketLocation"
    ]
    resources = ["*"] # Standard logs access
  }

  statement {
    sid    = "AllowS3ObjectAccess"
    effect = "Allow"
    actions = [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:GetObjectVersion"
    ]
    resources = [
      aws_s3_bucket.aws_s3_bucket.arn,
      "${aws_s3_bucket.aws_s3_bucket.arn}/*",
    ]
  }

  statement {
    sid    = "AllowBatchBuild"
    effect = "Allow"
    actions = [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild",
        "codebuild:StopBuild",
        "codebuild:BatchGetBuildBatches",
        "codebuild:StartBuildBatch"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "CodeStarConnectionAccess"
    effect = "Allow"
    actions = [
        "codestar-connections:GetConnectionToken",
        "codestar-connections:GetConnection",
        "codestar-connections:UseConnection",
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

  statement {
    sid    = "ECSDeployAccess"
    effect = "Allow"
    actions = [
        "ecs:DescribeServices",
        "ecs:DescribeTaskDefinition",
        "ecs:DescribeTasks",
        "ecs:ListTasks",
        "ecs:RegisterTaskDefinition",
        "ecs:UpdateService",
    ]
    resources = ["*"] 
  }

  statement {
    sid    = "IamPassRolePermissions"
    effect = "Allow"
    actions = [
        "iam:PassRole",
    ]
    resources = [
        aws_iam_role.toto_ecs_task_execution_role.arn,
        aws_iam_role.toto_ecs_task_role.arn,
    ]
    condition {
        test     = "StringEqualsIfExists"
        variable = "iam:PassedToService"
        values   = ["ecs-tasks.amazonaws.com", "codebuild.amazonaws.com"]
    }
  }

  # Basic CloudWatch access
  statement {
    sid    = "CloudWatchAccess"
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricData",
    ]
    resources = ["*"]
  }
}

# 3. Attach the policy to the CodePipeline role
resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "TotoCodePipelinePolicy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy_doc.json
}
