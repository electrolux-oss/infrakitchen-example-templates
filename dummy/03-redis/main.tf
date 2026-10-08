# Dummy counterpart of demo/03-aws-redis: same inputs/outputs, no cloud calls.

locals {
  engine = can(regex("^redis", var.family)) ? "redis" : "valkey"

  arn_prefix = "arn:aws:elasticache:${var.region}:${var.account}"
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
    name          = "${var.name}-redis"
    vpc_id        = var.vpc_id
    ingress_cidrs = var.ingress_cidrs
    port          = 6379
    tags = merge(var.tags, {
      Name      = "${var.name}-redis-sg"
      ManagedBy = "InfraKitchen"
    })
  }
}

resource "terraform_data" "subnet_group" {
  input = {
    name   = "${var.name}-redis-subnets"
    vpc_id = var.vpc_id
    tags = merge(var.tags, {
      Name = "${var.name}-redis-subnets"
    })
  }
}

resource "terraform_data" "parameter_group" {
  input = {
    name   = "${var.name}-${var.family}"
    family = var.family
    parameters = [
      for parameter in try(var.parameters.parameters, []) : {
        name  = parameter.name
        value = tostring(parameter.value)
      }
    ]
  }
}

resource "terraform_data" "user" {
  for_each = {
    rw = "on ~* ${var.default_user_access_string}"
    ro = "on ~* +@read"
  }

  input = {
    user_id       = "${var.user_prefix}-${each.key}"
    arn           = "${local.arn_prefix}:user:${var.user_prefix}-${each.key}"
    engine        = upper(local.engine)
    access_string = each.value
    auth_type     = "iam"
  }
}

resource "terraform_data" "user_group" {
  input = {
    user_group_id = "${var.user_prefix}-users"
    engine        = upper(local.engine)
    user_ids      = [for user in terraform_data.user : user.output.user_id]
  }
}

resource "random_id" "endpoint" {
  byte_length = 3

  keepers = {
    name = var.name
  }
}

resource "terraform_data" "replication_group" {
  input = {
    replication_group_id     = var.name
    arn                      = "${local.arn_prefix}:replicationgroup:${var.name}"
    engine                   = local.engine
    engine_version           = var.redis_version
    node_type                = var.node_type
    num_cache_clusters       = var.number_of_nodes
    parameter_group_name     = terraform_data.parameter_group.output.name
    subnet_group_name        = terraform_data.subnet_group.output.name
    security_group_ids       = [terraform_data.security_group.output.id]
    user_group_ids           = [terraform_data.user_group.output.user_group_id]
    primary_endpoint_address = "master.${var.name}.${random_id.endpoint.hex}.${var.region}.cache.amazonaws.com"
    reader_endpoint_address  = "replica.${var.name}.${random_id.endpoint.hex}.${var.region}.cache.amazonaws.com"
    tags = merge(var.tags, {
      Name = var.name
    })
  }
}
