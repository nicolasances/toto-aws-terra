########################################################
# This is an example of what needs to be created for a 
# Toto service to be deployed. 
# If mostly covers:
# 1. Github Repo creation, with secrets settings.
########################################################
resource "github_actions_environment_secret" "ecs_subnet_1" {
    repository = "aws-py-service"
    environment = var.toto_environment
    secret_name = "ecs_subnet_1"
    plaintext_value = aws_subnet.toto_pub_subnet_1.arn
}
resource "github_actions_environment_secret" "ecs_subnet_2" {
    repository = "aws-py-service"
    environment = var.toto_environment
    secret_name = "ecs_subnet_2"
    plaintext_value = aws_subnet.toto_pub_subnet_2.arn
}
resource "github_actions_environment_secret" "ecs_security_group" {
    repository = "aws-py-service"
    environment = var.toto_environment
    secret_name = "ecs_security_group"
    plaintext_value = aws_security_group.toto_open_service.arn
}