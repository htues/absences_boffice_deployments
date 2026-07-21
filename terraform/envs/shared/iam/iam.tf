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

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd",
  ]

  tags = merge(local.common_tags, {
    Name = "github-actions-oidc-provider"
  })
}

resource "aws_iam_role" "github_actions_deployer" {
  name = var.deployment_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "GitHubActionsAssumeRole"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = var.github_oidc_subjects
          }
        }
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = var.deployment_role_name
  })
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

  role       = aws_iam_role.github_actions_deployer.name
  policy_arn = aws_iam_policy.custom[each.value.policy_name].arn
}