output "route53_zone_id" {
  description = "Route53 hosted zone ID for shared DNS"
  value       = local.effective_route53_zone_id
}

output "route53_zone_name" {
  description = "Route53 hosted zone name for shared DNS"
  value       = var.root_domain_name
}

output "route53_name_servers" {
  description = "Name servers for the managed Route53 hosted zone. Empty when using an existing hosted zone ID."
  value       = local.create_route53_zone ? aws_route53_zone.root[0].name_servers : []
}

output "route53_record_names" {
  description = "Route53 DNS record names created for the shared application target"
  value       = [for record in aws_route53_record.application : record.fqdn]
}

output "application_urls" {
  description = "HTTPS URLs for the shared application DNS records"
  value       = [for record in aws_route53_record.application : "https://${record.fqdn}"]
}

output "load_balancer_dns_name" {
  description = "DNS name of the discovered application load balancer"
  value       = data.aws_lb.application.dns_name
}

output "load_balancer_url" {
  description = "HTTP URL of the discovered application load balancer"
  value       = "http://${data.aws_lb.application.dns_name}"
}
