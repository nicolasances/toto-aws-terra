########################################################
# This is an example of what needs to be created for a 
# Toto service to be deployed. 
# If mostly covers:
# 1. Github Repo creation, with secrets settings.
########################################################
data "github_repository" "toto_py_test_service_gh_repo" {
    full_name = "nicolasances/toto-py-test"
}

resource "github_repository_environment" "toto_py_test_gh_env" {
    repository = data.github_repository.toto_py_test_service_gh_repo.name
    environment = var.toto_environment
  
}
########################################################
# 1.1. Subnets
########################################################
resource "github_actions_environment_secret" "toto_py_test_ecs_subnet_1" {
    repository = data.github_repository.toto_py_test_service_gh_repo.name
    environment = var.toto_environment
    secret_name = "ecs_subnet_1"
    plaintext_value = aws_subnet.toto_pub_subnet_1.id
}
resource "github_actions_environment_secret" "toto_py_test_ecs_subnet_2" {
    repository = data.github_repository.toto_py_test_service_gh_repo.name
    environment = var.toto_environment
    secret_name = "ecs_subnet_2"
    plaintext_value = aws_subnet.toto_pub_subnet_2.id
}
########################################################
# 1.2. Security Groups
########################################################
resource "github_actions_environment_secret" "toto_py_test_ecs_security_group" {
    repository = data.github_repository.toto_py_test_service_gh_repo.name
    environment = var.toto_environment
    secret_name = "ecs_security_group"
    plaintext_value = aws_security_group.toto_open_service.id
}
########################################################
# 1.3. Load Balancer settings
########################################################
resource "github_actions_environment_secret" "toto_py_test_alb_listener_arn_secret" {
    repository = data.github_repository.toto_py_test_service_gh_repo.name
    environment = var.toto_environment
    secret_name = "alb_listener_arn"
    plaintext_value = aws_lb_listener.toto_alb_listener_https.arn
}
resource "github_actions_environment_secret" "toto_py_test_alb_dns_name_ghsecret" {
    repository = data.github_repository.toto_py_test_service_gh_repo.name
    environment = var.toto_environment
    secret_name = "alb_dns_name"
    plaintext_value = aws_lb.toto_alb.dns_name
}
resource "github_actions_environment_secret" "toto_py_test_alb_zone_id_ghsecret" {
    repository = data.github_repository.toto_py_test_service_gh_repo.name
    environment = var.toto_environment
    secret_name = "alb_zone_id"
    plaintext_value = aws_lb.toto_alb.zone_id
}
########################################################
# 1.4. Route 53 Zone
########################################################
resource "github_actions_environment_secret" "toto_py_test_route53_zone_id_ghsecret" {
    repository = data.github_repository.toto_py_test_service_gh_repo.name
    environment = var.toto_environment
    secret_name = "route53_zone_id"
    plaintext_value = var.aws_route53_zone_id
}
########################################################
# 1.5. IAM roles for ECS
########################################################
resource "github_actions_environment_secret" "toto_py_test_ecs_execution_role_arn_ghsecret" {
    repository = data.github_repository.toto_py_test_service_gh_repo.name
    environment = var.toto_environment
    secret_name = "ecs_execution_role_arn"
    plaintext_value = aws_iam_role.toto_ecs_task_execution_role.arn
}
resource "github_actions_environment_secret" "toto_py_test_ecs_task_role_arn_ghsecret" {
    repository = data.github_repository.toto_py_test_service_gh_repo.name
    environment = var.toto_environment
    secret_name = "ecs_task_role_arn"
    plaintext_value = aws_iam_role.toto_ecs_task_role.arn
}
########################################################
# 1.6. ECS Cluster info
########################################################
resource "github_actions_environment_secret" "toto_py_test_ecs_cluster_arn_ghsecret" {
    repository = data.github_repository.toto_py_test_service_gh_repo.name
    environment = var.toto_environment
    secret_name = "ecs_cluster_arn"
    plaintext_value = aws_ecs_cluster.ecs_cluster.arn
}
########################################################
# 1.7. AWS Access Key and Secret Access Key
########################################################
resource "github_actions_environment_secret" "toto_py_test_aws_access_key_ghsecret" {
    repository = data.github_repository.toto_py_test_service_gh_repo.name
    environment = var.toto_environment
    secret_name = "AWS_ACCESS_KEY_ID"
    plaintext_value = var.aws_access_key
}
resource "github_actions_environment_secret" "toto_py_test_aws_secret_access_key_ghsecret" {
    repository = data.github_repository.toto_py_test_service_gh_repo.name
    environment = var.toto_environment
    secret_name = "AWS_SECRET_ACCESS_KEY"
    plaintext_value = var.aws_secret_access_key
}

########################################################
# 1.8. ECR
########################################################
resource "awscc_ecr_repository" "toto_py_test_ecr_private_repo" {
  repository_name = "toto-py-test"
}
resource "github_actions_environment_secret" "toto_py_test_ecr_repo" {
    repository = data.github_repository.toto_py_test_service_gh_repo.name
    environment = var.toto_environment
    secret_name = "ECR_REPO"
    plaintext_value = awscc_ecr_repository.toto_py_test_ecr_private_repo.repository_name
}
########################################################
# 1.9. Terraform API Token
########################################################
resource "github_actions_environment_secret" "toto_py_test_tf_api_token_ghsecret" {
    repository = data.github_repository.toto_py_test_service_gh_repo.name
    environment = var.toto_environment
    secret_name = "TF_API_TOKEN"
    plaintext_value = var.tf_api_token
}
resource "github_actions_environment_secret" "toto_py_test_tf_workspace_ghsecret" {
    repository = data.github_repository.toto_py_test_service_gh_repo.name
    environment = var.toto_environment
    secret_name = "TF_WORKSPACE"
    plaintext_value = format("toto-py-test-%s", var.toto_environment)
}