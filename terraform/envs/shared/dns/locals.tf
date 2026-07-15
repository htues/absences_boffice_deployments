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
}
