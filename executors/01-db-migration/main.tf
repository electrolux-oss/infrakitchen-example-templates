locals {
  target = "${var.database_name}-${var.environment}"
}

resource "random_id" "migration" {
  count = var.migration_count

  byte_length = 3

  keepers = {
    target = local.target
    index  = count.index
  }
}

resource "terraform_data" "migration" {
  count = var.migration_count

  input = {
    version = format("%04d_%s", count.index + 1, random_id.migration[count.index].hex)
    target  = local.target
  }
}
