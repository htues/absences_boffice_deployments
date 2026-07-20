variable "project_name" {
  description = "Name of the project, used for resource naming and tagging"
  type        = string
  default     = "absencesbo"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Environment name for the load balancer stack"
  type        = string
  default     = "shared"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.environment))
    error_message = "Environment must contain only lowercase letters, numbers, and hyphens."
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

variable "target_environment" {
  description = "Environment name used to discover the target instance"
  type        = string
  default     = "experimental"
}

variable "target_component" {
  description = "Component name used to discover the target instance"
  type        = string
  default     = "dev"
}

variable "app_nodeport" {
  description = "NodePort used by the application traffic path"
  type        = number
  default     = 32322

  validation {
    condition     = var.app_nodeport >= 30000 && var.app_nodeport <= 32767
    error_message = "app_nodeport must be within the Kubernetes NodePort range: 30000-32767."
  }
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN used by the TLS listener"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:acm:[a-z0-9-]+:[0-9]{12}:certificate/[a-f0-9-]+$", var.acm_certificate_arn))
    error_message = "acm_certificate_arn must be a valid ACM certificate ARN."
  }
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
