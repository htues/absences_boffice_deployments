terraform {
  backend "s3" {
    bucket         = "absencesbo-terraform-state"
    key            = "iam/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "absencesbo-terraform-locks"
  }
}
