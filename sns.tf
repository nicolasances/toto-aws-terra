########################################################
# 1. Tome Topics
########################################################
resource "aws_sns_topic" "tome_topics_topic" {
  name = format("tome-events-topic-%s", var.toto_env)
}