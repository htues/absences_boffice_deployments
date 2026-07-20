output "route53_zone_id" {
  description = "Route53 hosted zone ID sourced from shared Route53 state"
  value       = data.terraform_remote_state.route53.outputs.route53_zone_id
}

output "route53_zone_name" {
  description = "Route53 hosted zone name sourced from shared Route53 state"
  value       = data.terraform_remote_state.route53.outputs.route53_zone_name
}

output "route53_name_servers" {
  description = "Name servers for the managed Route53 hosted zone"
  value       = data.terraform_remote_state.route53.outputs.route53_name_servers
}

output "route53_record_names" {
  description = "Route53 DNS record names created for the shared application target"
  value       = concat([for record in aws_route53_record.application : record.fqdn], [aws_route53_record.verification.fqdn])
}

output "application_urls" {
  description = "HTTPS URLs for the shared application DNS records"
  value       = [for record in aws_route53_record.application : "https://${record.fqdn}"]
}

output "load_balancer_dns_name" {
  description = "DNS name of the shared application load balancer"
  value       = data.terraform_remote_state.load_balancer.outputs.load_balancer_dns_name
}

output "load_balancer_url" {
  description = "HTTP URL of the shared application load balancer"
  value       = data.terraform_remote_state.load_balancer.outputs.load_balancer_url
}
