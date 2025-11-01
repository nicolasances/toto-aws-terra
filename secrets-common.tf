
resource "aws_secretsmanager_secret" "mongo_host_secret" {
  name = format("%s/%s", var.toto_env, "mongo-host")
  description = "MongoDB host"
}
resource "aws_secretsmanager_secret_version" "mongo_host_secret_version" {
  secret_id     = aws_secretsmanager_secret.mongo_host_secret.id
  secret_string = var.mongo_host
}
