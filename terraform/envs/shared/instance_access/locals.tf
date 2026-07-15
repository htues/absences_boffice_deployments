locals {
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = "shared"
      ManagedBy   = "Terraform"
      Component   = "shared"
    },
    var.tags
  )

  role_name            = "${var.project_name}-shared-ec2-ssm-role"
  instance_profile_name = "${var.project_name}-shared-ec2-ssm-profile"
}
