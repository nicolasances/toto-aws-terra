########################################################
# 1. Tome Topics
########################################################
resource "aws_sns_topic" "tome_topics_topic" {
  name = format("tome-events-topic-%s", var.toto_env)
}

resource "aws_sns_topic_subscription" "tome_topics_tome_ms_topics_subscription" {
  topic_arn = aws_sns_topic.tome_topics_topic.arn
  protocol  = "https"
  endpoint  = "https://tome-ms-topics-${var.gcp_endpoint_suffix}/events/topic"
}