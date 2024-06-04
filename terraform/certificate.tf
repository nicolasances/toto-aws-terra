########################################################
# 1. Request a Certificate
########################################################
resource "aws_acm_certificate" "toto_certificate" {
  domain_name = var.toto_domain_name
  validation_method = "DNS"
  subject_alternative_names = [ format("api.dev.toto.aws.%s", var.toto_domain_name), format("api.prod.toto.aws.%s", var.toto_domain_name) ]

}

resource "aws_route53_record" "certificate_dns_records" {
  for_each = {
    for dvo in aws_acm_certificate.toto_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.aws_route53_zone_id
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.toto_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_dns_records : record.fqdn]
}
