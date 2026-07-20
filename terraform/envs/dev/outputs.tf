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
  description = "IAM role name sourced from the shared instance access state"
  value       = data.terraform_remote_state.shared_instance_access.outputs.iam_role_name
}

output "iam_instance_profile_name" {
  description = "IAM instance profile name sourced from the shared instance access state"
  value       = data.terraform_remote_state.shared_instance_access.outputs.iam_instance_profile_name
}

output "ebs_volume_id" {
  description = "ID of the additional EBS data volume"
  value       = aws_ebs_volume.dev_data.id
}

output "app_nodeport" {
  description = "NodePort used by the k3s nginx service"
  value       = var.app_nodeport
}
