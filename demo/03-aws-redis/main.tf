provider "aws" {
  region = var.region
}

locals {
  engine = can(regex("^redis", var.family)) ? "redis" : "valkey"
}

data "aws_subnets" "elasticache" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "tag:Tier"
    values = ["elasticache"]
  }
}

resource "aws_security_group" "redis" {
  name        = "${var.name}-redis"
  description = "Redis access"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_cidrs

    content {
      from_port   = 6379
      to_port     = 6379
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name      = "${var.name}-redis-sg"
    ManagedBy = "InfraKitchen"
  })
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.name}-redis-subnets"
  subnet_ids = data.aws_subnets.elasticache.ids

  tags = merge(var.tags, {
    Name = "${var.name}-redis-subnets"
  })
}

resource "aws_elasticache_parameter_group" "redis" {
  name   = "${var.name}-${var.family}"
  family = var.family

  dynamic "parameter" {
    for_each = try(var.parameters.parameters, [])

    content {
      name  = parameter.value.name
      value = tostring(parameter.value.value)
    }
  }
}

resource "aws_elasticache_user" "rw" {
  user_id       = "${var.user_prefix}-rw"
  user_name     = "${var.user_prefix}-rw"
  engine        = upper(local.engine)
  access_string = "on ~* ${var.default_user_access_string}"

  authentication_mode {
    type = "iam"
  }
}

resource "aws_elasticache_user" "ro" {
  user_id       = "${var.user_prefix}-ro"
  user_name     = "${var.user_prefix}-ro"
  engine        = upper(local.engine)
  access_string = "on ~* +@read"

  authentication_mode {
    type = "iam"
  }
}

resource "aws_elasticache_user_group" "this" {
  engine        = upper(local.engine)
  user_group_id = "${var.user_prefix}-users"
  user_ids = [
    aws_elasticache_user.rw.user_id,
    aws_elasticache_user.ro.user_id
  ]
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id       = var.name
  description                = "${var.name} replication group"
  engine                     = local.engine
  engine_version             = var.redis_version
  node_type                  = var.node_type
  num_cache_clusters         = var.number_of_nodes
  parameter_group_name       = aws_elasticache_parameter_group.redis.name
  subnet_group_name          = aws_elasticache_subnet_group.redis.name
  security_group_ids         = [aws_security_group.redis.id]
  user_group_ids             = [aws_elasticache_user_group.this.user_group_id]
  apply_immediately          = true
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  tags = merge(var.tags, {
    Name = var.name
  })
}
