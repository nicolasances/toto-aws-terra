########################################################
# 1. IAM Roles for ECS Tasks
########################################################
# 1.1. Task Execution Role
resource "aws_iam_role" "toto_ecs_task_execution_role" {
  name = format("toto-ecs-task-execution-role-%s", var.toto_environment)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role = aws_iam_role.toto_ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# 1.2. Task Role
# This is a generic role that ECS Microservices should use in the Task Definition
resource "aws_iam_role" "toto_ecs_task_role" {
  name = format("toto-ecs-task-role-%s", var.toto_environment)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "ecs_task_role_secrets_manager" {
  role = aws_iam_role.toto_ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

########################################################
# 2. Cluster
########################################################
resource "aws_ecs_cluster" "ecs_cluster" {
  name = format("toto-%s", var.toto_environment)
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_capacity_providers" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = ["FARGATE"]
}
