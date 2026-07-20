resource "aws_acm_certificate" "application" {
  domain_name               = var.certificate_domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.common_tags, {
    Name = var.certificate_domain_name
  })
}

resource "aws_route53_record" "application_validation" {
  for_each = {
    for validation_option in aws_acm_certificate.application.domain_validation_options :
    validation_option.domain_name => {
      name   = validation_option.resource_record_name
      record = validation_option.resource_record_value
      type   = validation_option.resource_record_type
    }
  }

  allow_overwrite = true
  zone_id         = data.terraform_remote_state.route53.outputs.route53_zone_id
  name            = each.value.name
  type            = each.value.type
  ttl             = 60
  records         = [each.value.record]
}

resource "aws_acm_certificate_validation" "application" {
  certificate_arn = aws_acm_certificate.application.arn

  validation_record_fqdns = [
    for record in aws_route53_record.application_validation :
    record.fqdn
  ]
}