terraform {
  required_version = ">= 1.10.0"

  backend "s3" {
    bucket       = "absencesbo-terraform-state"
    key          = "shared/instance_access/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
}
