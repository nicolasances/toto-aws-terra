# ###############################################################
# ###############################################################
# THIS FILE SHOULD BE COPIED UNDER toto-aws-terra
# After that you can delete it
# ###############################################################
# ###############################################################
########################################################
# 0. Constants to reuse across
########################################################
locals {
  toto_microservice_name = "toto-ms-ex1"
}

########################################################
# 1. ECR Repository
########################################################
resource "aws_ecr_repository" "toto_ms_ex1_ecr_private_repo" {
  name = format("%s/%s", var.toto_env, local.toto_microservice_name)
}

########################################################
# 2. Task Definition
########################################################
resource "aws_ecs_task_definition" "toto_ms_ex1_service_task_def" {
  family = format("%s-%s", local.toto_microservice_name, var.toto_env)
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = aws_iam_role.toto_ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.toto_ecs_task_role.arn
  cpu = 1024
  memory = 2048
  network_mode = "awsvpc"
  container_definitions = jsonencode([
    {
      name      = local.toto_microservice_name
      image     = format("%s.dkr.ecr.%s.amazonaws.com/%s/%s:latest", data.aws_caller_identity.current.account_id, var.aws_region, var.toto_env, local.toto_microservice_name)
      environment = [
        {
            name = "HYPERSCALER", 
            value = "aws"
        }, 
        {
          name = "ENVIRONMENT", 
          value = var.toto_env
        },
      ]
      entryPoint = [
        "sh", "-c", "npm run start"
      ]
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs", 
        options = {
          awslogs-create-group = "true"
          awslogs-group = format("/ecs/%s", local.toto_microservice_name)
          awslogs-region = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

########################################################
# 3. Service
########################################################
resource "aws_ecs_service" "toto_ms_ex1_service" {
  name = local.toto_microservice_name
  cluster = aws_ecs_cluster.ecs_cluster.arn
  task_definition = aws_ecs_task_definition.toto_ms_ex1_service_task_def.arn
  desired_count = 1
  capacity_provider_strategy {
    base = 0
    capacity_provider = "FARGATE"
    weight = 1
  }
  network_configuration {
    subnets = [ aws_subnet.toto_ecs_subnet_1.id, aws_subnet.toto_ecs_subnet_2.id ]
    security_groups = [ aws_security_group.toto_loadbalancer_sg.id ]
    assign_public_ip = true
  }
#   load_balancer {
#     target_group_arn = aws_lb_target_group.service_tg.arn
#     container_name = local.toto_microservice_name
#     container_port = 8080
#   }
}

########################################################
# 4. CI/CD Pipeline
########################################################
# 4.1. Cloud Build
resource "aws_codebuild_project" "toto_ms_ex1_container_builder" {
  name          = format("%s-%s", local.toto_microservice_name, var.toto_env)
  service_role  = var.codebuild_role_arn
  build_timeout = "120"

  # --- ENVIRONMENT CONFIGURATION ---
  environment {
    # Building containers requires LINUX_CONTAINER type
    type          = "LINUX_CONTAINER"
    compute_type  = "BUILD_GENERAL1_MEDIUM"
    image         = format("%s.dkr.ecr.%s.amazonaws.com/%s/%s:latest", data.aws_caller_identity.current.account_id, var.aws_region, var.toto_env, local.toto_microservice_name)
    
    # CRITICAL: Enables Docker-in-Docker functionality (required for building containers)
    privileged_mode = true 
  }

  # --- SOURCE CONFIGURATION (GitHub via CodeStar Connection) ---
  source {
    type     = "GITHUB"
    location = "https://github.com/nicolasances/${local.toto_microservice_name}.git"
    
    # CRITICAL: Path to the buildspec file in the repository
    buildspec = "aws/codebuild/buildspec.yml" 

    # Authentication using the CodeStar Connection ARN
    auth {
      type     = "CODECONNECTIONS"
      resource = var.code_connection_arn
    }
  }

  # --- ARTIFACTS CONFIGURATION ---
  # Assuming the container is pushed to a registry (ECR), 
  # we can set the primary artifact to NO_ARTIFACTS.
  artifacts {
    type     = "NO_ARTIFACTS"
    location = aws_s3_bucket.codebuild_artifacts.bucket
  }

}