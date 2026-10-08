# Dummy RDS PostgreSQL instance: AWS-shaped inputs/outputs, no cloud calls.

locals {
  version_parts  = split(".", var.engine_version)
  family         = "postgres${local.version_parts[0]}"
  engine_version = length(local.version_parts) > 1 ? var.engine_version : "${var.engine_version}.1"
  port           = 5432
}

resource "random_id" "security_group" {
  byte_length = 8

  keepers = {
    vpc_id = var.vpc_id
  }
}

resource "terraform_data" "security_group" {
  input = {
    id            = "sg-${random_id.security_group.hex}"
    name          = "${var.name}-postgres"
    vpc_id        = var.vpc_id
    ingress_cidrs = var.ingress_cidrs
    port          = local.port
    tags = merge(var.tags, {
      Name      = "${var.name}-postgres-sg"
      ManagedBy = "InfraKitchen"
    })
  }
}

resource "terraform_data" "subnet_group" {
  input = {
    name        = "${var.name}-postgres-subnets"
    vpc_id      = var.vpc_id
    subnet_tier = "database"
    tags = merge(var.tags, {
      Name = "${var.name}-postgres-subnets"
    })
  }
}

resource "terraform_data" "parameter_group" {
  input = {
    name   = "${var.name}-${local.family}"
    family = local.family
    parameters = [
      for parameter in try(var.parameters.parameters, []) : {
        name         = parameter.name
        value        = tostring(parameter.value)
        apply_method = try(parameter.apply_method, "immediate")
      }
    ]
  }
}

resource "random_string" "endpoint" {
  length  = 12
  upper   = false
  special = false

  keepers = {
    account = var.account
    region  = var.region
  }
}

resource "random_string" "resource_id" {
  length  = 26
  lower   = false
  special = false

  keepers = {
    name = var.name
  }
}

resource "random_uuid" "secret" {
  keepers = {
    resource_id = random_string.resource_id.result
  }
}

resource "random_string" "secret_suffix" {
  length  = 6
  special = false

  keepers = {
    secret = random_uuid.secret.result
  }
}

resource "terraform_data" "postgres" {
  input = {
    identifier                          = var.name
    arn                                 = "arn:aws:rds:${var.region}:${var.account}:db:${var.name}"
    resource_id                         = "db-${random_string.resource_id.result}"
    engine                              = "postgres"
    engine_version_actual               = local.engine_version
    instance_class                      = var.instance_class
    allocated_storage                   = var.allocated_storage
    max_allocated_storage               = var.max_allocated_storage
    storage_type                        = "gp3"
    storage_encrypted                   = true
    db_name                             = var.db_name
    username                            = var.master_username
    master_user_secret_arn              = "arn:aws:secretsmanager:${var.region}:${var.account}:secret:rds!db-${random_uuid.secret.result}-${random_string.secret_suffix.result}"
    address                             = "${var.name}.${random_string.endpoint.result}.${var.region}.rds.amazonaws.com"
    port                                = local.port
    db_subnet_group_name                = terraform_data.subnet_group.output.name
    vpc_security_group_ids              = [terraform_data.security_group.output.id]
    parameter_group_name                = terraform_data.parameter_group.output.name
    multi_az                            = var.multi_az
    publicly_accessible                 = false
    backup_retention_period             = var.backup_retention_period
    iam_database_authentication_enabled = var.iam_database_authentication_enabled
    deletion_protection                 = var.deletion_protection
    final_snapshot_identifier           = var.skip_final_snapshot ? null : "${var.name}-final"
    tags                                = merge(var.tags, { Name = var.name })
  }

  lifecycle {
    precondition {
      condition     = var.max_allocated_storage >= var.allocated_storage
      error_message = "max_allocated_storage must be greater than or equal to allocated_storage."
    }
  }
}
