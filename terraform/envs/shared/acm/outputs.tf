output "acm_certificate_arn" {
  description = "Validated ACM certificate ARN for the shared application load balancer"
  value       = aws_acm_certificate_validation.application.certificate_arn
}

output "acm_certificate_domain_name" {
  description = "Primary ACM certificate domain name"
  value       = aws_acm_certificate.application.domain_name
}

output "acm_certificate_subject_alternative_names" {
  description = "ACM certificate subject alternative names"
  value       = aws_acm_certificate.application.subject_alternative_names
}

output "acm_validation_record_names" {
  description = "Route53 validation record names created for ACM"
  value = [
    for record in aws_route53_record.application_validation :
    record.name
  ]
}