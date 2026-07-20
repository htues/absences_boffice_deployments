locals {
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Component   = "shared"
    },
    var.tags
  )

  name_prefix = "${var.environment}-${var.project_name}-app"
}
