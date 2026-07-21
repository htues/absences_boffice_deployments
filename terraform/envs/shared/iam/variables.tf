variable "project_name" {
  description = "Name of the project, used for resource tagging"
  type        = string
  default     = "absencesbo"
}

variable "environment" {
  description = "Environment name used for tagging"
  type        = string
  default     = "shared"
}

variable "managed_by" {
  description = "Tag value used to identify the managing tool"
  type        = string
  default     = "terraform"
}

variable "layer" {
  description = "Tag value used to identify the Terraform layer"
  type        = string
  default     = "iam"
}

variable "policy_name_prefix" {
  description = "Optional prefix for generated IAM policy names"
  type        = string
  default     = "absencesbo"
}

variable "policy_path" {
  description = "IAM path assigned to generated managed policies"
  type        = string
  default     = "/"
}

variable "deployment_role_name" {
  description = "Default IAM role name that should receive the shared infrastructure policies"
  type        = string
  default     = "websystem-deployer"
}

variable "github_oidc_subjects" {
  description = "GitHub OIDC subject patterns allowed to assume the deployer role"
  type        = list(string)
  default = [
    "repo:htues@81975375/absences_boffice_deployments@1301927577:*"
  ]
}

variable "policy_role_attachments" {
  description = "Map of IAM role names to policy keys that should be attached to them"
  type        = map(list(string))
  default     = {}
}