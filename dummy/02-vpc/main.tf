# Dummy counterpart of demo/02-aws-vpc: same inputs/outputs, no cloud calls.

locals {
  azs = ["${var.region}a", "${var.region}b"]

  # Same netnum offsets as the AWS module: public +0, private +10, database +20, elasticache +30
  tier_offsets = {
    public      = 0
    private     = 10
    database    = 20
    elasticache = 30
  }

  subnets = merge([
    for tier, offset in local.tier_offsets : {
      for idx, az in local.azs : "${tier}-${az}" => {
        tier = tier
        az   = az
        cidr = cidrsubnet(var.cidr_block, 8, idx + offset)
      }
    }
  ]...)

  base_tags = merge(var.tags, {
    Name        = var.name
    Environment = "shared"
    ManagedBy   = "InfraKitchen"
  })
}

resource "random_id" "vpc" {
  byte_length = 8

  keepers = {
    name       = var.name
    cidr_block = var.cidr_block
  }
}

resource "terraform_data" "vpc" {
  input = {
    id                    = "vpc-${random_id.vpc.hex}"
    cidr_block            = var.cidr_block
    secondary_cidr_blocks = var.secondary_cidr_blocks
    owner_id              = var.account
    tags                  = local.base_tags
  }
}

resource "random_id" "igw" {
  byte_length = 8

  keepers = {
    vpc_id = terraform_data.vpc.output.id
  }
}

resource "terraform_data" "internet_gateway" {
  input = {
    id     = "igw-${random_id.igw.hex}"
    vpc_id = terraform_data.vpc.output.id
    tags = merge(local.base_tags, {
      Name = "${var.name}-igw"
    })
  }
}

resource "random_id" "subnet" {
  for_each = local.subnets

  byte_length = 8

  keepers = {
    vpc_id = terraform_data.vpc.output.id
    cidr   = each.value.cidr
  }
}

resource "terraform_data" "subnet" {
  for_each = local.subnets

  input = {
    id                = "subnet-${random_id.subnet[each.key].hex}"
    vpc_id            = terraform_data.vpc.output.id
    availability_zone = each.value.az
    cidr_block        = each.value.cidr
    tags = merge(local.base_tags, {
      Name = "${var.name}-${each.value.tier}-${each.value.az}"
      Tier = each.value.tier
    })
  }
}

resource "terraform_data" "public_route_table" {
  input = {
    vpc_id     = terraform_data.vpc.output.id
    gateway_id = terraform_data.internet_gateway.output.id
    subnet_ids = [for key, subnet in terraform_data.subnet : subnet.output.id if local.subnets[key].tier == "public"]
    tags = merge(local.base_tags, {
      Name = "${var.name}-public-rt"
    })
  }
}
