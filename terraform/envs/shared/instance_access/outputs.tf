output "iam_role_name" {
  description = "IAM role name attached to the shared EC2 instance"
  value       = aws_iam_role.ec2_ssm.name
}

output "iam_role_arn" {
  description = "IAM role ARN attached to the shared EC2 instance"
  value       = aws_iam_role.ec2_ssm.arn
}

output "iam_instance_profile_name" {
  description = "IAM instance profile name attached to the shared EC2 instance"
  value       = aws_iam_instance_profile.ec2_ssm.name
}
