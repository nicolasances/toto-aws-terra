########################################################
# 1. Tome Topics
########################################################
resource "aws_sns_topic" "tome_topics_topic" {
  name = format("tome-events-topic-%s", var.toto_env)
}

resource "aws_sns_topic_subscription" "tome_topics_tome_ms_topics_subscription" {
  topic_arn = aws_sns_topic.tome_topics_topic.arn
  protocol  = "https"
  endpoint  = "https://${var.domain_name}/tometopics/events/topic"
}

resource "aws_sns_topic_subscription" "tome_topics_tome_ms_agents_subscription" {
  topic_arn = aws_sns_topic.tome_topics_topic.arn
  protocol  = "https"
  endpoint  = "https://${var.domain_name}/tomeagents/events/topic"
}


########################################################
# 2. Topic-related Secrets
########################################################
resource "aws_secretsmanager_secret" "topic_name_tometopics_secret" {
  name        = format("%s/%s", var.toto_env, "tome_topics_topic_name")
  description = "Secret for the name of the topic for events on Tome Topic"
}
resource "aws_secretsmanager_secret_version" "topic_name_tometopics_secret_version" {
  secret_id     = aws_secretsmanager_secret.topic_name_tometopics_secret.id
  secret_string = aws_sns_topic.tome_topics_topic.arn
}

