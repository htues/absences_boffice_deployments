variable "project_name" {
  description = "Name of the project, used for tagging and consistent inputs"
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

variable "record_names" {
  description = "DNS names that should alias the shared application target"
  type        = list(string)
  default = [
    "exp.absencesbo.tamayo.dev"
  ]

  validation {
    condition = alltrue([
      for record_name in var.record_names :
      can(regex("^[a-z0-9.-]+\\.[a-z]{2,}$", record_name))
    ])
    error_message = "record_names must contain valid DNS names."
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

variable "lb_state_bucket" {
  description = "S3 bucket containing the Load Balancer Terraform remote state"
  type        = string
}

variable "lb_state_key" {
  description = "S3 key containing the Load Balancer Terraform remote state"
  type        = string
}

variable "lb_state_region" {
  description = "AWS region containing the Load Balancer Terraform remote state bucket"
  type        = string
  default     = "us-east-2"
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
