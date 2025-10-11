########################################################
# 1. JWT Signing Key
########################################################
resource "aws_secretsmanager_secret" "jwt_signing_key" {
  name = format("toto/%s/jwt-signing-key", var.toto_environment)
  description = format("Key to sign Toto JWT Tokens in %s environment", var.toto_environment)
}
resource "aws_secretsmanager_secret_version" "jwt_signing_key" {
  secret_id = aws_secretsmanager_secret.jwt_signing_key.id
  secret_string = var.jwt_signing_key
}

########################################################
# 2. MongoDB
########################################################
resource "aws_secretsmanager_secret" "secret_mongo_host" {
    name = format("toto/%s/mongo-host", var.toto_environment)
    description = format("Mongo host for the %s environment", var.toto_environment)
}
resource "aws_secretsmanager_secret_version" "secret_mongo_host_version" {
    secret_id = aws_secretsmanager_secret.secret_mongo_host.id
    secret_string = var.mongo_host
}
