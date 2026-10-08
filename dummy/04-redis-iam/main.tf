# Dummy Redis IAM credentials for a service account role (like 09-rds-postgres-credentials).
# Superset of demo/04-aws-redis-iam inputs/outputs, no cloud calls.

locals {
  policy_name    = "${var.policy_name}-redis-iam"
  redis_username = regex("user:([^:/]+)$", var.iam_user_arn)[0]

  redis_connect = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["elasticache:Connect"]
      Resource = [
        var.cluster_arn,
        var.iam_user_arn
      ]
    }]
  })
}

resource "terraform_data" "redis_user" {
  input = {
    name                 = local.redis_username
    arn                  = var.iam_user_arn
    replication_group    = var.cluster_arn
    endpoint             = var.redis_primary_endpoint
    authentication_mode  = "iam"
    service_account_role = var.aws_iam_role_name
  }
}

resource "terraform_data" "redis_iam" {
  input = {
    name        = local.policy_name
    arn         = "arn:aws:iam::${var.account}:policy/${local.policy_name}"
    description = "Allow IAM auth to ElastiCache Redis"
    policy      = local.redis_connect
    tags        = var.tags
  }
}

resource "terraform_data" "attach" {
  input = {
    role       = var.aws_iam_role_name
    policy_arn = terraform_data.redis_iam.output.arn
  }
}
