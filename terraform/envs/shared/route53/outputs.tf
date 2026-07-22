output "route53_zone_id" {
  description = "Route53 hosted zone ID for shared DNS"
  value       = local.effective_route53_zone_id
}

output "route53_zone_name" {
  description = "Route53 hosted zone name for shared DNS"
  value       = var.root_domain_name
}

output "route53_zone_arn" {
  description = "Route53 hosted zone ARN for shared DNS"
  value       = local.create_route53_zone ? aws_route53_zone.root[0].arn : "arn:aws:route53:::hostedzone/${var.route53_zone_id}"
}

output "route53_name_servers" {
  description = "Name servers for the managed Route53 hosted zone. Empty when using an existing hosted zone ID."
  value       = local.create_route53_zone ? aws_route53_zone.root[0].name_servers : []
}