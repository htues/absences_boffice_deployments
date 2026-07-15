data "aws_lb" "application" {
  name = local.application_load_balancer_name
}

resource "aws_route53_zone" "root" {
  count = local.create_route53_zone ? 1 : 0

  name = var.root_domain_name

  tags = merge(local.common_tags, {
    Name = var.root_domain_name
  })
}

resource "aws_route53_record" "application" {
  for_each = toset(var.record_names)

  zone_id = local.effective_route53_zone_id
  name    = each.value
  type    = "A"

  alias {
    name                   = data.aws_lb.application.dns_name
    zone_id                = data.aws_lb.application.zone_id
    evaluate_target_health = true
  }
}
