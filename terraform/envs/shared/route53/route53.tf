resource "aws_route53_zone" "root" {
  count = local.create_route53_zone ? 1 : 0

  name = var.root_domain_name

  tags = merge(local.common_tags, {
    Name = var.root_domain_name
  })
}