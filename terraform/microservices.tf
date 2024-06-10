module "toto-py-test" {
  source = "./toto-py-test"
  
  alb_dns_name = aws_lb.toto_alb.dns_name
  alb_listener_arn = aws_lb_listener.toto_alb_listener_https.arn
  alb_zone_id = aws_lb.toto_alb.zone_id

  aws_access_key = var.aws_access_key
  aws_account_id = var.aws_account_id
  aws_secret_access_key = var.aws_secret_access_key

  ecs_cluster_arn = aws_ecs_cluster.ecs_cluster.arn
  ecs_execution_role_arn = aws_iam_role.toto_ecs_task_execution_role.arn
  ecs_task_role_arn = aws_iam_role.toto_ecs_task_role.arn
  ecs_security_group = aws_security_group.toto_open_service.id
  ecs_subnet_1 = aws_subnet.toto_pub_subnet_1.id
  ecs_subnet_2 = aws_subnet.toto_pub_subnet_2.id

  route53_zone_id = var.aws_route53_zone_id

  tf_api_token = var.tf_api_token

  toto_environment = var.toto_environment
  toto_vpc_id = aws_vpc.toto_vpc.id
}