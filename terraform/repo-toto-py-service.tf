########################################################
# This is an example of what needs to be created for a 
# Toto service to be deployed. 
# If mostly covers:
# 1. Github Repo creation, with secrets settings.
########################################################
data "github_repository" "toto_py_service_repo" {
    full_name = "nicolasances/aws-py-service"
}
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
resource "github_actions_environment_secret" "ecs_security_group" {
    repository = data.github_repository.toto_py_service_repo.name
    environment = var.toto_environment
    secret_name = "ecs_security_group"
    plaintext_value = aws_security_group.toto_open_service.id
}
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
resource "github_actions_environment_secret" "route53_zone_id_ghsecret" {
    repository = data.github_repository.toto_py_service_repo.name
    environment = var.toto_environment
    secret_name = "route53_zone_id"
    plaintext_value = var.aws_route53_zone_id
}
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
resource "github_actions_environment_secret" "ecs_cluster_arn_ghsecret" {
    repository = data.github_repository.toto_py_service_repo.name
    environment = var.toto_environment
    secret_name = "ecs_cluster_arn"
    plaintext_value = aws_ecs_cluster.ecs_cluster.arn
}