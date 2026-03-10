data "aws_iam_policy_document" "redis_connect" {
  statement {
    effect = "Allow"
    actions = [
      "elasticache:Connect"
    ]
    resources = [
      var.cluster_arn,
      var.iam_user_arn
    ]
  }
}

resource "aws_iam_policy" "redis_iam" {
  name        = "${var.policy_name}-redis-iam"
  description = "Allow IAM auth to ElastiCache Redis"
  policy      = data.aws_iam_policy_document.redis_connect.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = var.aws_iam_role_name
  policy_arn = aws_iam_policy.redis_iam.arn
}
