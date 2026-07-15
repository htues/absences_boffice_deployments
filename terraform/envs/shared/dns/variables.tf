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

variable "route53_zone_id" {
  description = "Optional Route53 hosted zone ID for the shared DNS zone"
  type        = string
  default     = ""
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

variable "record_names" {
  description = "DNS names that should alias the shared application target"
  type        = list(string)
  default     = [
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

variable "target_environment" {
  description = "Environment name used to derive the application load balancer name"
  type        = string
  default     = "experimental"
}

variable "target_component" {
  description = "Component name used to derive the application load balancer name"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
