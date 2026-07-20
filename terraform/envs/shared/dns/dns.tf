data "terraform_remote_state" "route53" {
  backend = "s3"

  config = {
    bucket  = var.route53_state_bucket
    key     = var.route53_state_key
    region  = var.route53_state_region
    encrypt = true
  }
}

data "terraform_remote_state" "load_balancer" {
  backend = "s3"

  config = {
    bucket  = var.lb_state_bucket
    key     = var.lb_state_key
    region  = var.lb_state_region
    encrypt = true
  }
}

resource "aws_route53_record" "application" {
  for_each = toset(var.record_names)

  zone_id = data.terraform_remote_state.route53.outputs.route53_zone_id
  name    = each.value
  type    = "A"

  alias {
    name                   = data.terraform_remote_state.load_balancer.outputs.load_balancer_dns_name
    zone_id                = data.terraform_remote_state.load_balancer.outputs.load_balancer_zone_id
    evaluate_target_health = true
  }
}
