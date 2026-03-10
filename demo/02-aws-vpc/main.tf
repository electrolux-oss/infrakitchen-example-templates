data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
  base_tags = merge(var.tags, {
    Name        = var.name
    Environment = "shared"
    ManagedBy   = "terraform"
  })
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.base_tags, {
    Name = var.name
  })
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary" {
  for_each = toset(var.secondary_cidr_blocks)

  vpc_id     = aws_vpc.this.id
  cidr_block = each.value
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.base_tags, {
    Name = "${var.name}-igw"
  })
}

resource "aws_subnet" "public" {
  for_each = { for idx, az in local.azs : az => idx }

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = cidrsubnet(var.cidr_block, 8, each.value)
  map_public_ip_on_launch = true

  tags = merge(local.base_tags, {
    Name = "${var.name}-public-${each.key}"
    Tier = "public"
  })
}

resource "aws_subnet" "private" {
  for_each = { for idx, az in local.azs : az => idx }

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
  cidr_block        = cidrsubnet(var.cidr_block, 8, each.value + 10)

  tags = merge(local.base_tags, {
    Name = "${var.name}-private-${each.key}"
    Tier = "private"
  })
}

resource "aws_subnet" "database" {
  for_each = { for idx, az in local.azs : az => idx }

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
  cidr_block        = cidrsubnet(var.cidr_block, 8, each.value + 20)

  tags = merge(local.base_tags, {
    Name = "${var.name}-database-${each.key}"
    Tier = "database"
  })
}

resource "aws_subnet" "elasticache" {
  for_each = { for idx, az in local.azs : az => idx }

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
  cidr_block        = cidrsubnet(var.cidr_block, 8, each.value + 30)

  tags = merge(local.base_tags, {
    Name = "${var.name}-elasticache-${each.key}"
    Tier = "elasticache"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(local.base_tags, {
    Name = "${var.name}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}
