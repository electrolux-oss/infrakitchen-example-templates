# Dummy Kubernetes service account with an IRSA IAM role: AWS-shaped inputs/outputs, no cloud calls.

locals {
  role_name   = "${var.cluster_name}-${var.namespace}-${var.service_account_name}"
  oidc_issuer = trimprefix(var.oidc_issuer_url, "https://")

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = var.oidc_provider_arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${local.oidc_issuer}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
          "${local.oidc_issuer}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "random_id" "role" {
  byte_length = 8

  keepers = {
    role_name = local.role_name
  }
}

resource "terraform_data" "role" {
  input = {
    name               = local.role_name
    arn                = "arn:aws:iam::${var.account}:role/${local.role_name}"
    unique_id          = "AROA${upper(random_id.role.hex)}"
    assume_role_policy = local.assume_role_policy
    tags = merge(var.tags, {
      ManagedBy = "InfraKitchen"
    })
  }

  lifecycle {
    precondition {
      condition     = length(local.role_name) <= 64
      error_message = "IAM role name \"${local.role_name}\" exceeds 64 characters; shorten cluster_name, namespace or service_account_name."
    }
  }
}

resource "terraform_data" "policy_attachment" {
  for_each = toset(var.policy_arns)

  input = {
    role       = terraform_data.role.output.name
    policy_arn = each.value
  }
}

resource "random_uuid" "service_account" {
  keepers = {
    namespace = var.namespace
    name      = var.service_account_name
  }
}

resource "terraform_data" "service_account" {
  input = {
    name         = var.service_account_name
    namespace    = var.namespace
    uid          = random_uuid.service_account.result
    cluster_name = var.cluster_name
    annotations = {
      "eks.amazonaws.com/role-arn" = terraform_data.role.output.arn
    }
  }
}
