data "terraform_remote_state" "route53" {
  backend = "s3"

  config = {
    bucket  = "absencesbo-terraform-state"
    key     = "shared/route53/terraform.tfstate"
    region  = var.aws_region
    encrypt = true
  }
}

data "terraform_remote_state" "load_balancer" {
  backend = "s3"

  config = {
    bucket  = "absencesbo-terraform-state"
    key     = "shared/load_balancer/terraform.tfstate"
    region  = var.aws_region
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

resource "aws_route53_record" "verification" {
  zone_id = data.terraform_remote_state.route53.outputs.route53_zone_id
  name    = var.domain_verification_record["name"]
  type    = "CNAME"
  ttl     = 300
  records = [var.domain_verification_record["value"]]
}
