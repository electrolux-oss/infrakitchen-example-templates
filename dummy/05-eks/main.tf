# Dummy EKS cluster with a managed node group: AWS-shaped inputs/outputs, no cloud calls.

locals {
  azs = ["${var.region}a", "${var.region}b"]

  tags = merge(var.tags, {
    ManagedBy = "InfraKitchen"
  })
}

resource "random_id" "cluster" {
  byte_length = 16

  keepers = {
    account = var.account
    region  = var.region
    name    = var.name
  }
}

resource "random_id" "security_group" {
  byte_length = 8

  keepers = {
    vpc_id = var.vpc_id
  }
}

resource "terraform_data" "cluster_role" {
  input = {
    name        = "${var.name}-eks-cluster"
    arn         = "arn:aws:iam::${var.account}:role/${var.name}-eks-cluster"
    policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
    tags        = local.tags
  }
}

resource "terraform_data" "cluster" {
  input = {
    name                      = var.name
    arn                       = "arn:aws:eks:${var.region}:${var.account}:cluster/${var.name}"
    version                   = var.kubernetes_version
    role_arn                  = terraform_data.cluster_role.output.arn
    endpoint                  = "https://${upper(random_id.cluster.hex)}.gr7.${var.region}.eks.amazonaws.com"
    certificate_authority     = base64encode("-----BEGIN CERTIFICATE-----\nDUMMY-${random_id.cluster.hex}\n-----END CERTIFICATE-----\n")
    oidc_issuer               = "https://oidc.eks.${var.region}.amazonaws.com/id/${upper(random_id.cluster.hex)}"
    cluster_security_group_id = "sg-${random_id.security_group.hex}"
    vpc_id                    = var.vpc_id
    subnet_tier               = "private"
    endpoint_public_access    = var.endpoint_public_access
    public_access_cidrs       = var.public_access_cidrs
    authentication_mode       = "API"
    tags                      = local.tags
  }
}

resource "terraform_data" "oidc_provider" {
  input = {
    arn            = "arn:aws:iam::${var.account}:oidc-provider/${trimprefix(terraform_data.cluster.output.oidc_issuer, "https://")}"
    url            = terraform_data.cluster.output.oidc_issuer
    client_id_list = ["sts.amazonaws.com"]
  }
}

resource "terraform_data" "admin_access" {
  count = var.admin_role_arn == "" ? 0 : 1

  input = {
    cluster_name  = terraform_data.cluster.output.name
    principal_arn = var.admin_role_arn
    policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
    access_scope  = "cluster"
  }
}

resource "terraform_data" "node_role" {
  input = {
    name = "${var.name}-eks-node"
    arn  = "arn:aws:iam::${var.account}:role/${var.name}-eks-node"
    policy_arns = [
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    ]
    tags = local.tags
  }
}

resource "random_id" "node" {
  count = var.desired_size

  byte_length = 8

  keepers = {
    cluster = terraform_data.cluster.output.name
  }
}

resource "terraform_data" "node_group" {
  input = {
    name           = "${var.name}-default"
    cluster_name   = terraform_data.cluster.output.name
    node_role_arn  = terraform_data.node_role.output.arn
    subnet_tier    = var.node_subnet_tier
    instance_types = var.instance_types
    capacity_type  = var.capacity_type
    scaling = {
      desired_size = var.desired_size
      min_size     = var.min_size
      max_size     = var.max_size
    }
    instances = [
      for idx, node in random_id.node : {
        id                = "i-${node.hex}"
        availability_zone = local.azs[idx % length(local.azs)]
      }
    ]
    tags = local.tags
  }

  lifecycle {
    precondition {
      condition     = var.min_size <= var.desired_size && var.desired_size <= var.max_size
      error_message = "Node sizes must satisfy min_size <= desired_size <= max_size."
    }
  }
}
