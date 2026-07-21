data "aws_caller_identity" "current" {}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = var.managed_by
    Layer       = var.layer
  }

  default_policy_role_attachments = {
    (var.deployment_role_name) = [
      "web_destroy_infra",
      "web_eks_management",
      "web_iac_policy",
    ]
  }

  policy_files = fileset("${path.module}/json", "*.json")

  policy_documents = {
    for policy_file in local.policy_files :
    trimsuffix(policy_file, ".json") => templatefile("${path.module}/json/${policy_file}", {
      account_id = data.aws_caller_identity.current.account_id
    })
  }

  policy_role_attachments = {
    for attachment in flatten([
      for role_name, policy_names in merge(local.default_policy_role_attachments, var.policy_role_attachments) : [
        for policy_name in policy_names : {
          key         = "${role_name}:${policy_name}"
          role_name   = role_name
          policy_name = policy_name
        }
      ]
    ]) : attachment.key => attachment
  }
}

resource "aws_iam_policy" "custom" {
  for_each = local.policy_documents

  name        = var.policy_name_prefix == "" ? each.key : "${var.policy_name_prefix}-${each.key}"
  path        = var.policy_path
  description = "Terraform-managed policy loaded from ${each.key}.json"
  policy      = each.value

  tags = merge(local.common_tags, {
    Name = each.key
  })
}

resource "aws_iam_role_policy_attachment" "custom" {
  for_each = local.policy_role_attachments

  role       = each.value.role_name
  policy_arn = aws_iam_policy.custom[each.value.policy_name].arn
}
