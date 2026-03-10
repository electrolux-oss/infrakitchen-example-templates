data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_from_master" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.master_account_id}:root"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cicd_admin" {
  name                 = "${var.environment_name}-cicd-admin"
  assume_role_policy   = data.aws_iam_policy_document.assume_from_master.json
  max_session_duration = var.max_session_duration

  tags = merge(var.tags, {
    Environment = var.environment_name
    ManagedBy   = "terraform"
  })
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = aws_iam_role.cicd_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
