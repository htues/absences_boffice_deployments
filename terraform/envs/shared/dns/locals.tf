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

  create_route53_zone       = trimspace(var.route53_zone_id) == ""
  effective_route53_zone_id = local.create_route53_zone ? aws_route53_zone.root[0].zone_id : var.route53_zone_id

  application_load_balancer_name = "${var.target_environment}-${var.project_name}-${var.target_component}-nlb"
}
