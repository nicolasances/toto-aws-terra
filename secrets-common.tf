
resource "aws_secretsmanager_secret" "mongo_host_secret" {
  name = format("%s/%s", var.toto_env, "mongo-host")
  description = "MongoDB host"
}
resource "aws_secretsmanager_secret_version" "mongo_host_secret_version" {
  secret_id     = aws_secretsmanager_secret.mongo_host_secret.id
  secret_string = var.mongo_host
}

resource "aws_secretsmanager_secret" "toto_registry_endpoint_secret" {
  name = format("%s/%s", var.toto_env, "toto-registry-endpoint")
  description = "Toto Registry endpoint"
}
resource "aws_secretsmanager_secret_version" "toto_registry_endpoint_secret_version" {
  secret_id     = aws_secretsmanager_secret.toto_registry_endpoint_secret.id
  secret_string = format("https://%s/totoregistry", var.domain_name)
}