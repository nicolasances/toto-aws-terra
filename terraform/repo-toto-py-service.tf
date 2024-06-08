########################################################
# This is an example of what needs to be created for a 
# Toto service to be deployed. 
# If mostly covers:
# 1. Github Repo creation, with secrets settings.
########################################################
data "github_repository" "toto_py_service_repo" {
    full_name = "nicolasances/aws-py-service"
}
########################################################
# 1.1. Subnets
########################################################
resource "github_actions_environment_secret" "ecs_subnet_1" {
    repository = data.github_repository.toto_py_service_repo.name
    environment = var.toto_environment
    secret_name = "ecs_subnet_1"
    plaintext_value = aws_subnet.toto_pub_subnet_1.id
}
resource "github_actions_environment_secret" "ecs_subnet_2" {
    repository = data.github_repository.toto_py_service_repo.name
    environment = var.toto_environment
    secret_name = "ecs_subnet_2"
    plaintext_value = aws_subnet.toto_pub_subnet_2.id
}
########################################################
# 1.2. Security Groups
########################################################
resource "github_actions_environment_secret" "ecs_security_group" {
    repository = data.github_repository.toto_py_service_repo.name
    environment = var.toto_environment
    secret_name = "ecs_security_group"
    plaintext_value = aws_security_group.toto_open_service.id
}
########################################################
# 1.3. Load Balancer settings
########################################################
resource "github_actions_environment_secret" "alb_listener_arn_secret" {
    repository = data.github_repository.toto_py_service_repo.name
    environment = var.toto_environment
    secret_name = "alb_listener_arn"
    plaintext_value = aws_lb_listener.toto_alb_listener_https.arn
}
resource "github_actions_environment_secret" "alb_dns_name_ghsecret" {
    repository = data.github_repository.toto_py_service_repo.name
    environment = var.toto_environment
    secret_name = "alb_dns_name"
    plaintext_value = aws_lb.toto_alb.dns_name
}
resource "github_actions_environment_secret" "alb_zone_id_ghsecret" {
    repository = data.github_repository.toto_py_service_repo.name
    environment = var.toto_environment
    secret_name = "alb_zone_id"
    plaintext_value = aws_lb.toto_alb.zone_id
}
########################################################
# 1.4. Route 53 Zone
########################################################
resource "github_actions_environment_secret" "route53_zone_id_ghsecret" {
    repository = data.github_repository.toto_py_service_repo.name
    environment = var.toto_environment
    secret_name = "route53_zone_id"
    plaintext_value = var.aws_route53_zone_id
}
########################################################
# 1.5. IAM roles for ECS
########################################################
resource "github_actions_environment_secret" "ecs_execution_role_arn_ghsecret" {
    repository = data.github_repository.toto_py_service_repo.name
    environment = var.toto_environment
    secret_name = "ecs_execution_role_arn"
    plaintext_value = aws_iam_role.toto_ecs_task_execution_role.arn
}
resource "github_actions_environment_secret" "ecs_task_role_arn_ghsecret" {
    repository = data.github_repository.toto_py_service_repo.name
    environment = var.toto_environment
    secret_name = "ecs_task_role_arn"
    plaintext_value = aws_iam_role.toto_ecs_task_role.arn
}
########################################################
# 1.6. ECS Cluster info
########################################################
resource "github_actions_environment_secret" "ecs_cluster_arn_ghsecret" {
    repository = data.github_repository.toto_py_service_repo.name
    environment = var.toto_environment
    secret_name = "ecs_cluster_arn"
    plaintext_value = aws_ecs_cluster.ecs_cluster.arn
}
########################################################
# 1.7. AWS Access Key and Secret Access Key
########################################################
resource "github_actions_environment_secret" "aws_access_key_ghsecret" {
    repository = data.github_repository.toto_py_service_repo.name
    environment = var.toto_environment
    secret_name = "AWS_ACCESS_KEY_ID"
    plaintext_value = var.aws_access_key
}
resource "github_actions_environment_secret" "aws_secret_access_key_ghsecret" {
    repository = data.github_repository.toto_py_service_repo.name
    environment = var.toto_environment
    secret_name = "AWS_SECRET_ACCESS_KEY"
    plaintext_value = var.aws_secret_access_key
}

########################################################
# 1.3. Terraform API Token
########################################################
resource "github_actions_environment_secret" "tf_api_token_ghsecret" {
    repository = data.github_repository.toto_py_service_repo.name
    environment = var.toto_environment
    secret_name = "TF_API_TOKEN"
    plaintext_value = var.tf_api_token
}
resource "github_actions_environment_secret" "tf_workspace_ghsecret" {
    repository = data.github_repository.toto_py_service_repo.name
    environment = var.toto_environment
    secret_name = "TF_WORKSPACE"
    plaintext_value = format("aws-py-service-%s", var.toto_environment)
}