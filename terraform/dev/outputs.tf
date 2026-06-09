output "vpc_id" {
  description = "ID of the dev VPC"
  value       = aws_vpc.dev.id
}

output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "ID of the dev security group"
  value       = aws_security_group.dev.id
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.dev.id
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.dev.private_ip
}

output "public_ip" {
  description = "Elastic IP attached to the EC2 instance"
  value       = aws_eip.dev.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.dev.public_dns
}

output "iam_role_name" {
  description = "IAM role name attached to the EC2 instance"
  value       = aws_iam_role.ec2.name
}

output "iam_instance_profile_name" {
  description = "IAM instance profile name attached to the EC2 instance"
  value       = aws_iam_instance_profile.ec2.name
}

output "ebs_volume_id" {
  description = "ID of the additional EBS data volume"
  value       = aws_ebs_volume.dev_data.id
}

output "route53_zone_id" {
  description = "Route53 hosted zone ID used by the dev DNS records"
  value       = local.effective_route53_zone_id
}

output "route53_zone_name" {
  description = "Route53 hosted zone name used by the dev DNS records"
  value       = var.root_domain_name
}

output "route53_name_servers" {
  description = "Name servers for the managed Route53 hosted zone. Empty when using an existing hosted zone ID."
  value       = local.create_route53_zone ? aws_route53_zone.root[0].name_servers : []
}

output "route53_record_names" {
  description = "Route53 DNS record names created for the dev environment"
  value       = [for record in aws_route53_record.environment : record.fqdn]
}

output "application_urls" {
  description = "HTTPS URLs for the dev application DNS records"
  value       = [for record in aws_route53_record.environment : "https://${record.fqdn}"]
}

output "load_balancer_dns_name" {
  description = "Public DNS name of the dev application Network Load Balancer"
  value       = aws_lb.dev_app.dns_name
}

output "load_balancer_url" {
  description = "Public HTTP URL of the raw dev Network Load Balancer, mainly for debugging"
  value       = "http://${aws_lb.dev_app.dns_name}"
}

output "app_nodeport" {
  description = "NodePort used by the k3s nginx service"
  value       = var.app_nodeport
}