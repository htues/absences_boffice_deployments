resource "aws_route53_record" "environment" {
  for_each = toset(var.environment_dns_records)

  zone_id = var.route53_zone_id
  name    = each.value
  type    = "A"

  alias {
    name                   = aws_lb.dev_app.dns_name
    zone_id                = aws_lb.dev_app.zone_id
    evaluate_target_health = true
  }
}