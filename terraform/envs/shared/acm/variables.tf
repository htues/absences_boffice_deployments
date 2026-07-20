variable "project_name" {
  description = "Name of the project, used for resource naming and tagging"
  type        = string
  default     = "absencesbo"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"

  validation {
    condition     = can(regex("^us-east-2$", var.aws_region))
    error_message = "Only us-east-2 is supported for this project"
  }
}

variable "root_domain_name" {
  description = "Root DNS domain managed in Route53"
  type        = string
  default     = "tamayo.dev"

  validation {
    condition     = can(regex("^[a-z0-9.-]+\\.[a-z]{2,}$", var.root_domain_name))
    error_message = "root_domain_name must be a valid domain name."
  }
}

variable "certificate_domain_name" {
  description = "Primary domain name for the ACM certificate"
  type        = string
  default     = "exp.absencesbo.tamayo.dev"

  validation {
    condition     = can(regex("^[a-z0-9.-]+\\.[a-z]{2,}$", var.certificate_domain_name))
    error_message = "certificate_domain_name must be a valid domain name."
  }
}

variable "subject_alternative_names" {
  description = "Additional domain names for the ACM certificate"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for domain_name in var.subject_alternative_names :
      can(regex("^[a-z0-9.*-]+\\.[a-z]{2,}$", domain_name))
    ])
    error_message = "subject_alternative_names must contain valid DNS names."
  }
}

variable "route53_state_bucket" {
  description = "S3 bucket containing the Route53 Terraform remote state"
  type        = string
}

variable "route53_state_key" {
  description = "S3 key containing the Route53 Terraform remote state"
  type        = string
}

variable "route53_state_region" {
  description = "AWS region containing the Route53 Terraform remote state bucket"
  type        = string
  default     = "us-east-2"
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}