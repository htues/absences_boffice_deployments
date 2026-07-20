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
  description = "Environment name"
  type        = string
  default     = "experimental"

  validation {
    condition     = contains(["experimental"], var.environment)
    error_message = "Environment must be 'experimental' for the dev stack."
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

variable "vpc_cidr" {
  description = "CIDR block for the dev VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid CIDR block."
  }
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"

  validation {
    condition     = can(cidrhost(var.public_subnet_cidr, 0))
    error_message = "public_subnet_cidr must be a valid CIDR block."
  }
}

variable "instance_type" {
  description = "EC2 instance type for the dev node"
  type        = string
  default     = "t3.small"
}

variable "root_volume_type" {
  description = "Root EBS volume type"
  type        = string
  default     = "gp3"
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB"
  type        = number
  default     = 30

  validation {
    condition     = var.root_volume_size >= 8
    error_message = "root_volume_size must be at least 8 GiB."
  }
}

variable "data_volume_size" {
  description = "Additional EBS volume size in GiB"
  type        = number
  default     = 20

  validation {
    condition     = var.data_volume_size >= 1
    error_message = "data_volume_size must be at least 1 GiB."
  }
}

variable "data_volume_type" {
  description = "Additional EBS volume type"
  type        = string
  default     = "gp3"
}

variable "data_device_name" {
  description = "Device name used to attach the additional EBS volume"
  type        = string
  default     = "/dev/sdf"
}

variable "allowed_nodeport_cidrs" {
  description = "CIDR blocks allowed to access Kubernetes NodePort services directly"
  type        = list(string)
  default     = []
}

variable "allowed_web_cidrs" {
  description = "CIDR blocks allowed to access HTTP/HTTPS/NodePort services"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_k3s_cidrs" {
  description = "CIDR blocks allowed to access the k3s API server"
  type        = list(string)
  default     = []
}

variable "app_nodeport" {
  description = "NodePort exposed by the k3s nginx service and targeted by the AWS Network Load Balancer"
  type        = number
  default     = 32322

  validation {
    condition     = var.app_nodeport >= 30000 && var.app_nodeport <= 32767
    error_message = "app_nodeport must be within the Kubernetes NodePort range: 30000-32767."
  }
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
