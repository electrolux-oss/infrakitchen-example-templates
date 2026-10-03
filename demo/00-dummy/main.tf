locals {
  prefix = "${var.name}-${var.environment}"
}

resource "random_id" "deployment" {
  byte_length = 4

  keepers = {
    prefix = local.prefix
  }
}

resource "random_pet" "instance" {
  count = var.instance_count

  prefix = local.prefix
  length = 2
}

resource "terraform_data" "deployment" {
  input = {
    deployment_id = random_id.deployment.hex
    instances     = random_pet.instance[*].id
    tags          = var.tags
  }
}
