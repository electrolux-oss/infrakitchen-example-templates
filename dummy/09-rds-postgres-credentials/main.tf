# Dummy RDS PostgreSQL IAM credentials (like demo/04-aws-redis-iam): AWS-shaped inputs/outputs, no cloud calls.

locals {
  policy_name = "${var.policy_name}-rds-iam"
  db_user_arn = "arn:aws:rds-db:${var.region}:${var.account}:dbuser:${var.db_instance_resource_id}/${var.db_username}"

  rds_connect = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["rds-db:connect"]
      Resource = [local.db_user_arn]
    }]
  })
}

resource "terraform_data" "db_user" {
  input = {
    name       = var.db_username
    database   = var.db_name
    host       = var.db_instance_address
    roles      = ["rds_iam"]
    privileges = var.privileges
  }
}

resource "terraform_data" "rds_iam" {
  input = {
    name        = local.policy_name
    arn         = "arn:aws:iam::${var.account}:policy/${local.policy_name}"
    description = "Allow IAM auth to RDS PostgreSQL"
    policy      = local.rds_connect
    tags        = var.tags
  }
}

resource "terraform_data" "attach" {
  input = {
    role       = var.aws_iam_role_name
    policy_arn = terraform_data.rds_iam.output.arn
  }
}
