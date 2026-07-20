data "terraform_remote_state" "shared_instance_access" {
  backend = "s3"

  config = {
    bucket  = "absencesbo-terraform-state"
    key     = "shared/instance_access/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}
