########################################################
# 1. IAM Roles for ECS Tasks
########################################################
# 1.1. Task Execution Role
resource "aws_iam_role" "toto_ecs_task_execution_role" {
  name = format("toto-ecs-task-execution-role-%s", var.toto_env)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role = aws_iam_role.toto_ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment_cloudwatch" {
  role = aws_iam_role.toto_ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# 1.2. Task Role
# This is a generic role that ECS Microservices should use in the Task Definition
resource "aws_iam_role" "toto_ecs_task_role" {
  name = format("toto-ecs-task-role-%s", var.toto_env)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "ecs_task_role_secrets_manager" {
  role = aws_iam_role.toto_ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}
resource "aws_iam_role_policy_attachment" "ecs_task_role_s3_full_access" {
  role = aws_iam_role.toto_ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_role_policy_attachment" "ecs_task_role_bedrock_full_access" {
  role = aws_iam_role.toto_ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonBedrockFullAccess"
}
resource "aws_iam_role_policy_attachment" "ecs_task_role_sns_full_access" {
  role = aws_iam_role.toto_ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}

# Policy to allow ECS tasks to run other ECS tasks (for whispering job triggering)
resource "aws_iam_policy" "ecs_run_task_policy" {
  name        = format("toto-ecs-run-task-policy-%s", var.toto_env)
  description = "Allow ECS tasks to run other ECS tasks"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:RunTask"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = [
          aws_iam_role.toto_ecs_task_execution_role.arn,
          aws_iam_role.toto_ecs_task_role.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_run_task" {
  role = aws_iam_role.toto_ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_run_task_policy.arn
}

########################################################
# 2. Cluster
########################################################
resource "aws_ecs_cluster" "ecs_cluster" {
  name = format("toto-%s-cluster", var.toto_env)
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_capacity_providers" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = ["FARGATE"]
}
