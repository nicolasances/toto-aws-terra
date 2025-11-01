# ###############################################################
# ###############################################################
# THIS FILE SHOULD BE COPIED UNDER toto-aws-terra
# After that you can delete it
# ###############################################################
# ###############################################################

########################################################
# 1. ECR Repository
########################################################
resource "aws_ecr_repository" "gale_broker_ecr_private_repo" {
  name = format("%s/%s", var.toto_env, "gale-broker")
}

########################################################
# 2. Task Definition
########################################################
resource "aws_ecs_task_definition" "gale_broker_service_task_def" {
  family = format("%s-%s", "gale-broker", var.toto_env)
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = aws_iam_role.toto_ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.toto_ecs_task_role.arn
  cpu = 1024
  memory = 2048
  network_mode = "awsvpc"
  container_definitions = jsonencode([
    {
      name      = "gale-broker"
      image     = format("%s.dkr.ecr.%s.amazonaws.com/%s/%s:latest", data.aws_caller_identity.current.account_id, var.aws_region, var.toto_env, "gale-broker")
      environment = [
        {
            name = "HYPERSCALER", 
            value = "aws"
        }, 
        {
          name = "ENVIRONMENT", 
          value = var.toto_env
        },
        {
          name = "SQS_QUEUE_URL",
          value = aws_sqs_queue.gale_broker_queue.url
        }
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
          awslogs-group = format("/ecs/%s/%s", var.toto_env, "gale-broker")
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
resource "aws_ecs_service" "gale_broker_service" {
  name = "gale-broker"
  cluster = aws_ecs_cluster.ecs_cluster.arn
  task_definition = aws_ecs_task_definition.gale_broker_service_task_def.arn
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
  load_balancer {
    target_group_arn = aws_lb_target_group.gale_broker_service_tg.arn
    container_name = "gale-broker"
    container_port = 8080
  }
}

########################################################
# 4. CI/CD Pipeline
########################################################
# 4.1. Cloud Build
resource "aws_codebuild_project" "gale_broker_container_builder" {
  name          = format("%s-%s", "gale-broker", var.toto_env)
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = "120"

  # --- ENVIRONMENT CONFIGURATION ---
  environment {
    # Using AWS managed Amazon Linux image
    type          = "LINUX_CONTAINER"
    compute_type  = "BUILD_GENERAL1_MEDIUM"
    image         = "aws/codebuild/amazonlinux-x86_64-standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    
    # CRITICAL: Enables Docker-in-Docker functionality (required for building containers)
    privileged_mode = true 
  }

  # --- SOURCE CONFIGURATION (GitHub via CodeStar Connection) ---
  source {
    type     = "GITHUB"
    location = "https://github.com/nicolasances/gale-broker.git"
    
    # CRITICAL: Path to the buildspec file in the repository
    buildspec = "aws/codebuild/buildspec-${var.toto_env}.yml"

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
    type = "NO_ARTIFACTS"
  }

}

############################################################################################
# 4.2. CodePipeline
# AWS CodePipeline Resource
resource "aws_codepipeline" "gale_broker_ecs_pipeline" {
  name     = "gale-broker-ecs-pipeline-${var.toto_env}"
  role_arn = aws_iam_role.codepipeline_role.arn

  # Artifact store definition
  artifact_store {
    location = aws_s3_bucket.codepipeline_artifacts.bucket
    type     = "S3"
  }

  # --- Stage 1: Source (GitHub via CodeConnections) ---
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn    = var.code_connection_arn
        FullRepositoryId = "nicolasances/gale-broker"
        BranchName       = var.toto_env == "prod" ? "prod" : "dev"
      }
    }
  }

  # --- Stage 2: Build (Reuse existing CodeBuild Project) ---
  stage {
    name = "Build"
    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.gale_broker_container_builder.name
      }
    }
  }

  # --- Stage 3: Deploy (Amazon ECS) ---
  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["BuildArtifact"]
      version         = "1"

      configuration = {
        ClusterName = aws_ecs_cluster.ecs_cluster.name
        ServiceName = aws_ecs_service.gale_broker_service.name
        # The imagedefinitions.json file must be created by the CodeBuild step
        # and included in the BuildArtifact output.
        FileName    = "imagedefinitions.json" 
      }
    }
  }
}

########################################################
# 5. Load Balancer
########################################################
# 5.1. Target Groups
#    This section creates the Target Group for this service.
########################################################
resource "aws_lb_target_group" "gale_broker_service_tg" {
  name = format("%s-tg-%s", "gale-broker", var.toto_env)
  port = 8080
  protocol = "HTTP"
  vpc_id = aws_vpc.toto_vpc.id
  target_type = "ip"

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 15
    healthy_threshold   = 2
    unhealthy_threshold = 5
    matcher             = "200"
  }
}

##############################################################
# 5.2. ALB Listener Rules
##############################################################
resource "aws_lb_listener_rule" "gale_broker_alb_listener_rule" {
  listener_arn = aws_lb_listener.toto_alb_listener_http_8080.arn
  condition {
    path_pattern {
      values = ["/galebroker/*"]
    }
  }
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.gale_broker_service_tg.arn
  }
}
resource "aws_lb_listener_rule" "gale_broker_alb_listener_rule_https" {
  listener_arn = aws_lb_listener.toto_alb_listener_https.arn
  condition {
    path_pattern {
      values = ["/galebroker/*"]
    }
  }
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.gale_broker_service_tg.arn
  }
}


##############################################################
# 6. SQS Queue
##############################################################
resource "aws_sqs_queue" "gale_broker_queue" {
  name = format("%s-%s", "gale-broker", var.toto_env)
  visibility_timeout_seconds = 300
}

# IAM Policy for SQS Access
resource "aws_iam_policy" "gale_broker_sqs_policy" {
  name        = format("%s-sqs-policy-%s", "gale-broker", var.toto_env)
  description = "Allow ECS task to send and receive messages from gale-broker queue"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl"
        ]
        Resource = aws_sqs_queue.gale_broker_queue.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "gale_broker_sqs_policy_attachment" {
  role       = aws_iam_role.toto_ecs_task_role.name
  policy_arn = aws_iam_policy.gale_broker_sqs_policy.arn
}
