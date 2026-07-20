data "terraform_remote_state" "route53" {
  backend = "s3"

  config = {
    bucket = var.route53_state_bucket
    key    = var.route53_state_key
    region = var.route53_state_region
  }
}