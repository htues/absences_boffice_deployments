data "terraform_remote_state" "shared" {
  backend = "s3"

  config = {
    bucket  = "absencesbo-terraform-state"
    key     = "shared/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}

resource "aws_route53_record" "environment" {
  for_each = toset(var.environment_dns_records)

  zone_id = data.terraform_remote_state.shared.outputs.route53_zone_id
  name    = each.value
  type    = "A"

  alias {
    name                   = aws_lb.dev_app.dns_name
    zone_id                = aws_lb.dev_app.zone_id
    evaluate_target_health = true
  }
}