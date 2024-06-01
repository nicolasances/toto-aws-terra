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