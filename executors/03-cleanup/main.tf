locals {
  prefix = "${var.target}-${var.environment}"
}

resource "random_pet" "stale_item" {
  count = var.stale_item_count

  prefix = local.prefix
  length = 2
}

resource "terraform_data" "cleanup" {
  input = {
    target        = local.prefix
    removed_items = random_pet.stale_item[*].id
  }
}
