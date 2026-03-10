resource "random_id" "module_run" {
  byte_length = 4
}

locals {
  normalized = {
    name               = var.name
    instance_count     = var.instance_count
    enabled            = var.enabled
    subnet_ids         = var.subnet_ids
    tags               = var.tags
    settings           = var.settings
    services           = var.services
    availability_zones = tolist(var.availability_zones)
    dynamic_payload    = var.dynamic_payload
  }
}
