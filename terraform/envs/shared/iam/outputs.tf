output "policy_arns" {
  description = "Managed IAM policy ARNs keyed by JSON file name without the .json suffix"
  value       = { for name, policy in aws_iam_policy.custom : name => policy.arn }
}

output "policy_names" {
  description = "Managed IAM policy names keyed by JSON file name without the .json suffix"
  value       = { for name, policy in aws_iam_policy.custom : name => policy.name }
}

output "policy_role_attachments" {
  description = "Role-to-policy attachment IDs keyed by attachment key"
  value       = { for key, attachment in aws_iam_role_policy_attachment.custom : key => attachment.id }
}
