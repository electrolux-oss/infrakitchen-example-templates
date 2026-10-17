locals {
  prefix = "${var.dataset}-${var.environment}"
}

resource "random_uuid" "record" {
  count = var.record_count

  keepers = {
    prefix = local.prefix
  }
}

resource "terraform_data" "import" {
  input = {
    dataset = var.dataset
    records = random_uuid.record[*].result
  }
}
