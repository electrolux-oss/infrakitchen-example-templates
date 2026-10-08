# Dummy counterpart of demo/01-aws-account: same inputs/outputs, no cloud calls.

locals {
  role_name = "${var.environment_name}-cicd-admin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { AWS = "arn:aws:iam::${var.master_account_id}:root" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "random_id" "role" {
  byte_length = 8

  keepers = {
    account   = var.account
    role_name = local.role_name
  }
}

resource "terraform_data" "cicd_admin" {
  input = {
    name                 = local.role_name
    arn                  = "arn:aws:iam::${var.account}:role/${local.role_name}"
    unique_id            = "AROA${upper(random_id.role.hex)}"
    assume_role_policy   = local.assume_role_policy
    max_session_duration = var.max_session_duration

    tags = merge(var.tags, {
      Environment = var.environment_name
      ManagedBy   = "InfraKitchen"
    })
  }
}

resource "terraform_data" "admin" {
  input = {
    role       = terraform_data.cicd_admin.output.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  }
}
