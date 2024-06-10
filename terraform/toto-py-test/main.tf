########################################################
# This is an example of what needs to be created for a 
# Toto service to be deployed. 
# If mostly covers:
# 1. Github Repo creation, with secrets settings.
########################################################
data "github_repository" "service_gh_repo" {
    full_name = "nicolasances/toto-py-test"
}

resource "github_repository_environment" "gh_env" {
    repository = local.github_repo
    environment = var.toto_environment
  
}
########################################################
# 1.1. VPC and Subnets
########################################################
resource "github_actions_environment_secret" "toto_vpc_id" {
    repository = local.github_repo
    environment = var.toto_environment
    secret_name = "toto_vpc_id"
    plaintext_value = var.toto_vpc_id
}
resource "github_actions_environment_secret" "ecs_subnet_1" {
    repository = local.github_repo
    environment = var.toto_environment
    secret_name = "ecs_subnet_1"
    plaintext_value = var.ecs_subnet_1
}
resource "github_actions_environment_secret" "ecs_subnet_2" {
    repository = local.github_repo
    environment = var.toto_environment
    secret_name = "ecs_subnet_2"
    plaintext_value = var.ecs_subnet_2
}
########################################################
# 1.2. Security Groups
########################################################
resource "github_actions_environment_secret" "ecs_security_group" {
    repository = local.github_repo
    environment = var.toto_environment
    secret_name = "ecs_security_group"
    plaintext_value = var.ecs_security_group
}
########################################################
# 1.3. Load Balancer settings
########################################################
resource "github_actions_environment_secret" "alb_listener_arn_secret" {
    repository = local.github_repo
    environment = var.toto_environment
    secret_name = "alb_listener_arn"
    plaintext_value = var.alb_listener_arn
}
resource "github_actions_environment_secret" "alb_dns_name_ghsecret" {
    repository = local.github_repo
    environment = var.toto_environment
    secret_name = "alb_dns_name"
    plaintext_value = var.alb_dns_name
}
resource "github_actions_environment_secret" "alb_zone_id_ghsecret" {
    repository = local.github_repo
    environment = var.toto_environment
    secret_name = "alb_zone_id"
    plaintext_value = var.alb_zone_id
}
########################################################
# 1.4. Route 53 Zone
########################################################
resource "github_actions_environment_secret" "route53_zone_id_ghsecret" {
    repository = local.github_repo
    environment = var.toto_environment
    secret_name = "route53_zone_id"
    plaintext_value = var.route53_zone_id
}
########################################################
# 1.5. IAM roles for ECS
########################################################
resource "github_actions_environment_secret" "ecs_execution_role_arn_ghsecret" {
    repository = local.github_repo
    environment = var.toto_environment
    secret_name = "ecs_execution_role_arn"
    plaintext_value = var.ecs_execution_role_arn
}
resource "github_actions_environment_secret" "ecs_task_role_arn_ghsecret" {
    repository = local.github_repo
    environment = var.toto_environment
    secret_name = "ecs_task_role_arn"
    plaintext_value = var.ecs_task_role_arn
}
########################################################
# 1.6. ECS Cluster info
########################################################
resource "github_actions_environment_secret" "ecs_cluster_arn_ghsecret" {
    repository = local.github_repo
    environment = var.toto_environment
    secret_name = "ecs_cluster_arn"
    plaintext_value = var.ecs_cluster_arn
}
########################################################
# 1.7. AWS Account Access Key and Secret Access Key
########################################################
resource "github_actions_environment_secret" "aws_access_key_ghsecret" {
    repository = local.github_repo
    environment = var.toto_environment
    secret_name = "AWS_ACCESS_KEY_ID"
    plaintext_value = var.aws_access_key
}
resource "github_actions_environment_secret" "aws_secret_access_key_ghsecret" {
    repository = local.github_repo
    environment = var.toto_environment
    secret_name = "AWS_SECRET_ACCESS_KEY"
    plaintext_value = var.aws_secret_access_key
}
resource "github_actions_environment_secret" "aws_account_id_ghsecret" {
    repository = local.github_repo
    environment = var.toto_environment
    secret_name = "aws_account_id"
    plaintext_value = var.aws_account_id
}

########################################################
# 1.8. ECR
########################################################
resource "aws_ecr_repository" "ecr_private_repo" {
  name = "toto-py-test"
}
resource "github_actions_environment_secret" "ecr_repo" {
    repository = local.github_repo
    environment = var.toto_environment
    secret_name = "ECR_REPO"
    plaintext_value = aws_ecr_repository.ecr_private_repo.name
}
########################################################
# 1.9. Terraform API Token
########################################################
resource "github_actions_environment_secret" "tf_api_token_ghsecret" {
    repository = local.github_repo
    environment = var.toto_environment
    secret_name = "TF_API_TOKEN"
    plaintext_value = var.tf_api_token
}
resource "github_actions_environment_secret" "tf_workspace_ghsecret" {
    repository = local.github_repo
    environment = var.toto_environment
    secret_name = "TF_WORKSPACE"
    plaintext_value = format("toto-py-test-%s", var.toto_environment)
}