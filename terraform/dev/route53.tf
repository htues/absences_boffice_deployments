locals {
  create_route53_zone       = trimspace(var.route53_zone_id) == ""
  effective_route53_zone_id = local.create_route53_zone ? aws_route53_zone.root[0].zone_id : var.route53_zone_id
}

resource "aws_route53_zone" "root" {
  count = local.create_route53_zone ? 1 : 0

  name = var.root_domain_name

  tags = merge(local.common_tags, {
    Name = var.root_domain_name
  })
}

resource "aws_route53_record" "environment" {
  for_each = toset(var.environment_dns_records)

  zone_id = local.effective_route53_zone_id
  name    = each.value
  type    = "A"

  alias {
    name                   = aws_lb.dev_app.dns_name
    zone_id                = aws_lb.dev_app.zone_id
    evaluate_target_health = true
  }
}