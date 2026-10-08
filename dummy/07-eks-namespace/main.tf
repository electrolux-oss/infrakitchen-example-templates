# Dummy Kubernetes namespace on an EKS cluster: AWS-shaped inputs/outputs, no cloud calls.

resource "random_uuid" "namespace" {
  keepers = {
    cluster_name = var.cluster_name
    namespace    = var.namespace
  }
}

resource "terraform_data" "namespace" {
  input = {
    name         = var.namespace
    uid          = random_uuid.namespace.result
    cluster_name = var.cluster_name
    cluster_arn  = "arn:aws:eks:${var.region}:${var.account}:cluster/${var.cluster_name}"
    labels = merge(var.labels, {
      "kubernetes.io/metadata.name"  = var.namespace
      "app.kubernetes.io/managed-by" = "InfraKitchen"
    })
    annotations = var.tags
  }
}

resource "terraform_data" "resource_quota" {
  input = {
    name      = "${var.namespace}-quota"
    namespace = terraform_data.namespace.output.name
    hard = {
      "requests.cpu"    = var.resource_quota.requests_cpu
      "requests.memory" = var.resource_quota.requests_memory
      "limits.cpu"      = var.resource_quota.limits_cpu
      "limits.memory"   = var.resource_quota.limits_memory
      "pods"            = tostring(var.resource_quota.pods)
    }
  }
}
