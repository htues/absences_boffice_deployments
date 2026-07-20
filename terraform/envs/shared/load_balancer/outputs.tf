output "load_balancer_arn" {
  description = "ARN of the shared application network load balancer"
  value       = aws_lb.application.arn
}

output "load_balancer_dns_name" {
  description = "DNS name of the shared application network load balancer"
  value       = aws_lb.application.dns_name
}

output "load_balancer_zone_id" {
  description = "Canonical hosted zone ID of the shared application network load balancer"
  value       = aws_lb.application.zone_id
}

output "load_balancer_url" {
  description = "HTTP URL of the shared application network load balancer"
  value       = "http://${aws_lb.application.dns_name}"
}

output "load_balancer_https_url" {
  description = "HTTPS URL of the shared application network load balancer"
  value       = "https://${aws_lb.application.dns_name}"
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN used by the shared network load balancer"
  value       = data.terraform_remote_state.acm.outputs.acm_certificate_arn
}

output "target_group_arn" {
  description = "ARN of the target group used by the shared network load balancer"
  value       = aws_lb_target_group.application.arn
}
